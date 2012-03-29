// lecture_view.js?lecture_id=%d&quiz_id=%d&quiz_url=%s

/*
    Globals
    --------
    VIDEO_WIDTH, VIDEO_HEIGHT
    LECTURE_ID, QUIZ_ID, QUIZ_URL
    SOURCES, SUBTITLES, CUE_POINTS
    explanation_dialog
    QL_player
    seeked_play_handler
    quiz_cue_point_queue
*/

(function() {
    window.GET = get_js_query_parameters();
    window.LECTURE_PLAYER = decodeURIComponent(window.GET['lecture_player']);
    window.LECTURE_SPEED = decodeURIComponent(window.GET['lecture_speed']);
    window.LECTURE_ID = decodeURIComponent(window.GET['lecture_id']);
    window.QUIZ_ID = decodeURIComponent(window.GET['quiz_id']);
    window.QUIZ_URL = decodeURIComponent(window.GET['quiz_url']);
    window.LECTURE_SPEED_URL = decodeURIComponent(window.GET['lecture_speed_url']);
    window.IFRAME_URL = decodeURIComponent(window.GET['iframe_url']);
})();

function quiz_cue_point_handler(triggered_cue_point) {
    window.IN_QUIZ = true;
    var index = triggered_cue_point.index;

    this.mediaelement_handle.pause();
    
    window.QUIZ_OVERLAYS[index].css({'z-index': 1000});
    enable_overlay_tabbable(index);
    MathJax.Hub.Queue(["Typeset", MathJax.Hub, window.QUIZ_OVERLAYS[index][0]]);

    for(var i = 0; i < window.QUIZ_OVERLAYS.length; i++){
        if(i != index){
            window.QUIZ_OVERLAYS[i].css('z-index', -1);
            disable_overlay_tabbable(i);
        }
    }

    // Announce Quiz
    $('#QL_aria_announcer').html('In video quiz');

    this.refresh_overlay();
}

function continue_to_next_quiz(mediaelement_handle) {
   if (window.quiz_cue_point_queue.length > 0) {
       // If there are more quizzes left, then continue to them
        var cue_point = window.quiz_cue_point_queue.shift();
        quiz_cue_point_handler.call(window.QL_player, cue_point);
    } else {
        // No quizzes left - can play
        mediaelement_handle.play();
    }
}

function enable_overlay_tabbable(index){
    if(!window.QUIZ_FINISHED[index]){
        window.QUIZ_OVERLAYS[index]
            .find('input[type=radio],input[type=checkbox],input[type=text],textarea,select')
            .removeAttr('disabled');
    }
    window.QUIZ_OVERLAYS[index]
        .find('input[type=button]')
        .removeAttr('disabled');
    window.QUIZ_OVERLAYS[index].find('a').show();
}

function disable_overlay_tabbable(index){
    window.QUIZ_OVERLAYS[index]
        .find('input[type=radio],input[type=checkbox],input[type=text],textarea,select')
        .attr('disabled', 'disabled');
    window.QUIZ_OVERLAYS[index]
        .find('input[type=button]')
        .attr('disabled', 'disabled');
    window.QUIZ_OVERLAYS[index].find('a').hide();
}

function initialize_player() {
    window.QL_player = new QL_Player({
            suffix: 'first',
            sources: SOURCES,
            subtitles: SUBTITLES,
            width: VIDEO_WIDTH,
            height: VIDEO_HEIGHT,
            enableAutosize: false,
            cue_points: CUE_POINTS,
            cue_point_handler: function(triggered_cue_points) {
                var i;
                var cue_point;

                // Only do stuff if they were actually cue points triggered
                if (triggered_cue_points.length > 0) {
                    window.quiz_cue_point_queue = [];

                    for (i = 0; i < triggered_cue_points.length; i++){
                        if (triggered_cue_points[i].type == 'quiz') {
                            window.quiz_cue_point_queue.push(triggered_cue_points[i]);
                        } else {
                            // Other cue point type?
                        }
                    }

                   if (window.quiz_cue_point_queue.length > 0) {
                        cue_point = window.quiz_cue_point_queue.shift();
                        quiz_cue_point_handler.call(this, cue_point);
                    }

                }

            }, // cue_point_handler

            install_success_handler: function(media, DOMnode, mediaelement) {
                QL_player.mediaelement_media.addEventListener('seeked', window.seeked_play_handler, false);
                QL_player.mediaelement_media.addEventListener('play', window.seeked_play_handler, false);
                // Configure slides viewer
                if(typeof(SlideViewer) === 'function' && typeof(slides) === 'object'){
                    window.slide_viewer = new SlideViewer(slides, mediaelement, QL_player.mediaelement_media);
                    $('#lecture_view_dialog').append(window.slide_viewer.navElem);
                    //$('.mejs-fullscreen-button').hide();
                }
            }

            });

    // Have to make this global so the closure install_success_handler can access it
    window.seeked_play_handler = function() {
        if (window.IN_QUIZ) {
            // Hide explanation dialog if necessary
            if(typeof(window.explanation_dialog) === 'object'){
                window.explanation_dialog.dialog('close');
                delete(window.explanation_dialog);
            }

            for(var i = 0; i < window.QUIZ_OVERLAYS.length; i++){
                window.QUIZ_OVERLAYS[i].css('z-index', -1);
                disable_overlay_tabbable(i);
            }

            window.IN_QUIZ = false;
            QL_player.mediaelement_media.play();
        }
    };

    var install_opts = {};
    if(window.LECTURE_PLAYER === 'html5') install_opts['mode'] = 'auto';
    else if(window.LECTURE_PLAYER === 'flash') install_opts['mode'] = 'shim';
    QL_player.install_at($('#QL_player_container'), install_opts);

    // Configure iframe
    if(typeof(window.IFRAME_URL) === 'string' && window.IFRAME_URL !== ''){
        IFrame = new IframeViewer(QL_player, window.IFRAME_URL);
    }
    // Configure slides
    if(typeof(window.slide_viewer) === 'object'){
        QL_player.add_overlay(window.slide_viewer.overlayElem);
    }
}

function preload_cue_point(cue_point){
    var i, j;
    var time_total_rail;
    var quiz_container, quiz_form;
    var submit_button, skip_button, continue_button, show_explanation_button;
    var video_quiz_status_div, attempt_number_field;
    var post_answer_url;
    var mediaelement_handle;
    var attempt_number;

    quiz_container = $('<div></div>').addClass('quiz_container');
    quiz_form = $('<form></form>');
    attempt_number_field = $('<input></input>').attr('type', 'hidden').attr('name', 'attempt_number');

    video_quiz_status_div = $('<div></div>').addClass('video_quiz_status_div');

    submit_button = $('<input></input>').addClass('video_quiz_submit_button')
                                        .addClass('btn')
                                        .addClass('primary')
                                        .attr('type', 'button')
                                        .attr('value', 'Submit');
    skip_button = $('<input></input>').addClass('video_quiz_skip_button')
                                      .addClass('btn')
                                      .attr('type', 'button')
                                      .attr('value', 'Skip');
    continue_button = $('<input></input>').addClass('video_quiz_continue_button')
                                      .addClass('btn')
                                      .addClass('success')
                                      .attr('type', 'button')
                                      .attr('value', 'Continue');
    show_explanation_button = $('<input></input>').addClass('video_quiz_show_explanation_button')
                                      .addClass('btn')
                                      .attr('type', 'button')
                                      .attr('value', 'Explanation');

    post_answer_url = cue_point.post_answer_url;

    video_quiz_status_div.hide();

    /*
        Submit
    */
    submit_button.click( function() {

        submit_button.attr('disabled', 'disabled');
        continue_button.attr('disabled', 'disabled');

        var answer_data, merge_temp, merge_first, merge_val;

        attempt_number++;
        attempt_number_field.val(attempt_number);

        // Check if there are elements to be merged
        merge_temp = quiz_form.find('.merge');
        if (merge_temp.length > 0) {
            // Okay, there are elements to be merged
            // Duplicate the first element, and then set its value to
            // the concatenation of the values of all elements to merge,
            // separated by \n
            merge_first = merge_temp.eq(0).clone();
            merge_val = '';
            merge_temp.each( function(index) {
                merge_val = merge_val + $(this).val() + "\n";
            });
            // Remove trailing \n
            merge_val = merge_val.substring(merge_val, merge_val.length - 1);

            merge_first.val(merge_val);
        } else {
            // Not elements to be merged, make dummy element
            merge_first = $('<input></input>');
        }

        // Get user's answers
        answer_data = quiz_form.find('*').not('.merge');
        answer_data = answer_data.add(merge_first);
        answer_data = answer_data.serialize();

        // This button does nothing but indicate the the message box is clickable
        var close_button = $('<a></a>')
            .html('&times;')
            .attr('href', '#')
            .attr('title', 'Close Message')
            .addClass('close')
            .click(function(e){e.preventDefault()});

        // Change status
        video_quiz_status_div.html('Submitting...').append(close_button).css('color', '#000').fadeIn();
        close_button.click(function(e){e.preventDefault()});
        $('#QL_aria_announcer').html('Submitting');

        $.post(post_answer_url, answer_data, function (data) {
            submit_button.removeAttr('disabled');
            continue_button.removeAttr('disabled');

            if (data.status != "success") {
                video_quiz_status_div.html('An error occured. Try again.').append(close_button).css('color', '#000').fadeIn();
                close_button.click(function(e){e.preventDefault()});
                $('#QL_aria_announcer').html('An error occured. Try again.');
                return;
            } else {

                // Check if answer was correct
                if (data.data.correct) {
                    // Correct answer
                    video_quiz_status_div.html('Correct!').append(close_button).css('color', '#0c0').fadeIn();
                    close_button.click(function(e){e.preventDefault()});
                    $('#QL_aria_announcer').html('Correct!');
                } else {
                    // Incorrect answer
                    if (data.data.can_continue) {
                        if(quiz_container.find('.video_quiz_overlay .styledRadio').length > 0 || quiz_container.find('.video_quiz_overlay .styledCheckbox').length > 0){
                            video_quiz_status_div.html('Incorrect. See correct answer above.').append(close_button).css('color', '#c00').fadeIn();
                            close_button.click(function(e){e.preventDefault()});
                            $('#QL_aria_announcer').html('Incorrect. See correct answer above.');
                        }
                        else
                        {
                            video_quiz_status_div.html('Incorrect.').append(close_button).css('color', '#c00').fadeIn();
                            close_button.click(function(e){e.preventDefault()});
                            $('#QL_aria_announcer').html('Incorrect.');
                        }
                    } else {
                        video_quiz_status_div.html('Incorrect. Try again.').append(close_button).css('color', '#c00');
                        close_button.click(function(e){e.preventDefault()});
                        $('#QL_aria_announcer').html('Incorrect. Try again.');
                    }
                }

                // Check if we can continue
                if (data.data.can_continue) {

                    window.QUIZ_FINISHED[cue_point.index] = true;
                    var answerDivs = quiz_container.find('.video_quiz_overlay .quiz_option');
                    var answerOptions = quiz_container.find('.video_quiz_overlay input');
                    var styledRadios = quiz_container.find('.video_quiz_overlay .styledRadio');
                    var styledCheckboxes = quiz_container.find('.video_quiz_overlay .styledCheckbox');
                    for(var i = 0; i < data.data.correct_answers.length; i++){
                        var answerDiv = answerDivs.eq(i);
                        var styledRadio = styledRadios.eq(i);
                        var styledCheckbox = styledCheckboxes.eq(i);
                        var answerOption = answerOptions.eq(i);
                        if(data.data.correct_answers[i]){
                            
                            answerDiv.addClass('correct_answer');
                            
                            // check it
                            styledRadio.addClass('checked selected');
                            styledCheckbox.addClass('checked');
                            answerOption.attr('checked', 'checked');
                        }
                        else{
                            // Uncheck it
                            styledRadio.removeClass('checked selected');
                            styledCheckbox.removeClass('checked');
                            answerOption.removeAttr('checked');
                        }
                    }
                    
                    quiz_form.find('input,textarea').attr('disabled', 'disabled');
                    styledRadios.addClass('disabled');
                    styledCheckboxes.addClass('disabled');
                    submit_button.hide();
                    skip_button.hide();
                    continue_button.show();

                    if (typeof data.data.explanation != 'undefined') {
                        show_explanation_button.show();

                        // If explanation is empty, then hide the explanation button
                        if (data.data.explanation.length <= 0)
                            show_explanation_button.hide();
                        show_explanation_button.click( function() {
                            if(typeof(window.explanation_dialog) === 'object') return;
                            var explanation_div;
                            var explanation_close_button, explanation_close_button_div;

                            explanation_close_button = $('<input></input>').addClass('video_explanation_close_button')
                                                                           .attr('type', 'button')
                                                                           .attr('value', 'Ok')
                                                                           .click(
                                                                                function() {
                                                                                    window.explanation_dialog.dialog('close');
                                                                                    delete window.explanation_dialog;
                                                                                    
                                                                                });

                            explanation_close_button_div = $('<div></div>').css('text-align', 'center').css('padding-top', '30px');
                            explanation_close_button_div.append(explanation_close_button);

                            explanation_div = $('<div></div>').html(data.data.explanation).append(explanation_close_button_div);

                            // Expose explanation_dialog for seeked_play_handler / continue button to use
                            window.explanation_dialog = explanation_div.dialog({
                                title: 'Explanation',
                                stack: true,
                                position: 'center',
                                width: 'auto',
                                height: 'auto'
                            });
                            MathJax.Hub.Queue(["Typeset", MathJax.Hub, explanation_div[0]]);

                        });
                    }

                }

            } // if (data.status != "success")

       }, 'json').error(function(){
            video_quiz_status_div.html('An error occured. Try again.').append(close_button).css('color', '#000');
            $('#QL_aria_announcer').html('An error occurred. Try again.');
            submit_button.removeAttr('disabled');
            continue_button.removeAttr('disabled');
        });

    });

    /*
        Skip
    */

    skip_button.click( function() {
        // TODO: Note that user skipped question?
        continue_to_next_quiz(QL_player.mediaelement_handle);
    });

    /*
        Continue
    */
    continue_button.click( function() {
        // Hide explanation if necessary
        if(typeof(window.explanation_dialog) === 'object'){
            window.explanation_dialog.dialog('close');
            delete(window.explanation_dialog);
        }


        continue_to_next_quiz(QL_player.mediaelement_handle);
    });

    attempt_number = 0;
    // Overlay background
    
    var background_type = cue_point.background;
    var background_src = cue_point.background_src;

     if (background_type == 'color') {
        quiz_container.css('background', background_src);
    } else if (background_type == 'image') {
        quiz_container.css('background-image', 'url(' + background_src+')')
                                       .css('background-size','100% 100%');
    } else if (background_type == 'transparent') {
        // Make overlay background and MediaElement overlay play button transparent
        quiz_container.css('background', 'transparent');
        // window.QL_player.elements.canvas_container.find('div.mejs-layers div.mejs-overlay-play').css('opacity', 0.0);
    }

    // Overlay HTML
    quiz_form.html(cue_point.html);
    quiz_form.find('input[type=radio],input[type=checkbox],input[type=text],textarea,select').keydown(function(event){
        var ESC_KEY = 27;
        if(event.keyCode !== 27){
            event.stopPropagation();
        }
    }); // Prevent video shortcuts
    quiz_form.append(attempt_number_field); // Append hidden attempt_number field
    quiz_container.append(quiz_form);
    continue_button.hide();
    show_explanation_button.hide();
    quiz_container.append(submit_button)
                  .append(skip_button)
                  .append(continue_button)
                  .append(show_explanation_button)
                  .append(video_quiz_status_div);


    // Hide status div on click
    video_quiz_status_div.click(function(){
        video_quiz_status_div.fadeOut();
    });

    // Hide on mouseover for video_quiz_status_div
    /* var quizStatusTimer = null;
    video_quiz_status_div.mouseenter(function(){
        quizStatusTimer = setTimeout(function(){video_quiz_status_div.fadeOut('slow');}, 1000);
    });
    video_quiz_status_div.mouseleave(function(){
        if(typeof(quizStatusTimer) === 'number'){
            clearTimeout(quizStatusTimer);
            quizStatusTimer = null;
        }
    });*/
    
    // If 0 elements -- no inputs to submit, then just show continue
    if ($(quiz_form).find('input[type=radio],input[type=checkbox],input[type=text],textarea,select').length <= 0) {
        submit_button.hide();
        skip_button.hide();
        continue_button.show();
    }

    return quiz_container;
}

$(document).ready( function() {

    // Initialise sources and subtitles from the hidden divs
    window.SOURCES = $.parseJSON($('#source_data').html());
    window.SUBTITLES = $.parseJSON($('#subtitle_data').html());

    window.CUE_POINTS = [];
    window.VIDEO_WIDTH = 960;
    window.VIDEO_HEIGHT = 540;
    window.IN_QUIZ = false;

    window.QUIZ_FINISHED = [];
    window.QUIZ_OVERLAYS = [];
    $.getJSON(QUIZ_URL+'?method=get_question_list&quiz_id='+QUIZ_ID, function(data) {
        if (data.status != 'success') {
            alert('Error retrieving quiz for this lecture');
            // Warn, but initialize player anyway
        } else {
            var j = 0;
            for (var i = 0; i < data.data.length; i++){
                if(data.data[i].time !== 0){
                    var cue_point = { time: data.data[i].time,
                                      index: j,
                                      type: 'quiz',
                                      name: 'quiz_' + j,
                                      question_id: data.data[i].question_id,
                                      html: data.data[i].html,
                                      background: data.data[i].background,
                                      background_src: data.data[i].background_src,
                                      post_answer_url: data.data[i].post_answer_url };
                    window.CUE_POINTS[j] = cue_point;
                    window.QUIZ_OVERLAYS[j] = preload_cue_point(cue_point);
                    window.QUIZ_FINISHED[j] = false;
                    j++;
                }
            }
        }

        initialize_player_and_controls();

        // Render buttons
        for (var i = 0; i < window.QUIZ_OVERLAYS.length; i++){

            // QL_player.elements.quiz_overlay.append(window.QUIZ_OVERLAYS[i]);
            window.QUIZ_OVERLAYS[i].css('z-index', -1);
            
            QL_player.add_overlay(window.QUIZ_OVERLAYS[i]);
            window.QUIZ_OVERLAYS[i].find('input[type=radio]').screwDefaultButtons({
                width: 24,
                height: 24
            });

            window.QUIZ_OVERLAYS[i].find('input[type=checkbox]').screwDefaultButtons({
                width: 24,
                height: 24
            });
            disable_overlay_tabbable(i);

        }

        // Render MathJax
        MathJax.Hub.Configured();
        for (var i = 0; i < window.QUIZ_OVERLAYS.length; i++){
            MathJax.Hub.Queue(["Typeset", MathJax.Hub, window.QUIZ_OVERLAYS[i][0]]);
        }

        
    }).error(function(jqXHR, textStatus, errorThrown) {
        initialize_player_and_controls();
    });
;


});

var getCSRFToken = function(){
    //Check cookie exists
    if(typeof(document.cookie) !== 'string'){
        return '';
    }

    // Parse cookie
    var cookie = document.cookie;
    var pattern = /csrf_token=([^;]+)/;
    var results = pattern.exec(cookie);

    // Return match if exists
    if(typeof(results[1]) === 'string'){
        return results[1];
    }
    else{
        return '';
    }
}

var initialize_log = function(){
    //initLogger();
}

var update_speed = function(){
    update_speed_display();
    delayed_update_speed_preference();
}

var update_speed_display = function(){
    $('#QL_controls_speed_display').text('Speed: ' + QL_player.get_speed().toFixed(2) + 'x');
}

var updateSpeedPreferenceTimer = null;
var delayed_update_speed_preference = function(){
    var delay = 1000; // one second debounce
    if(typeof(updateSpeedPreferenceTimer) === 'number'){
        clearTimeout(updateSpeedPreferenceTimer);
        updateSpeedPreferenceTimer = null;
    }
    updateSpeedPreferenceTimer = setTimeout(update_speed_preference, delay)
}
var update_speed_preference = function(){
    var speed = QL_player.get_speed();
    var csrf_token = getCSRFToken();
    if(typeof(LECTURE_SPEED_URL) === 'string' && LECTURE_SPEED_URL){
        $.post(LECTURE_SPEED_URL, {'lecture_speed': speed, '__csrf-token': csrf_token});
    }
}

var initialize_player_and_controls = function(){
    initialize_player();
    initialize_log();
    if(typeof(window.parent.view_previous_lecture) === 'function' && typeof(window.parent.view_previous_lecture) === 'function'){
        $('#QL_controls_previous').show().click( function(e) {
            e.preventDefault()
            window.parent.view_previous_lecture(LECTURE_ID);
        } );
        $('#QL_controls_next').show().click( function(e) {
            e.preventDefault()
            window.parent.view_next_lecture(LECTURE_ID);
        } );
    }
    if(typeof(window.parent.setCuepoint) === 'function'){
        $('.set-cuepoint-group').show();
        $('#set-cuepoint-link').click(function(e){
            e.preventDefault();
            if(typeof(QL_player) === 'object' && typeof(QL_player.mediaelement_media) === 'object'){
                window.parent.setCuepoint(QL_player.mediaelement_media.currentTime);
            }
        });
    }
    if(QL_player.is_set_speed_enabled() && !(mejs.MediaFeatures.isAndroid ||
            mejs.MediaFeatures.isBustedAndroid ||
            mejs.MediaFeatures.isiOS ||
            mejs.MediaFeatures.isiPad ||
            mejs.MediaFeatures.isiPhone)){
        
        var speedPreference = Number(LECTURE_SPEED);
        if(speedPreference > 0){
            QL_player.set_speed(speedPreference);
            update_speed_display();
        }

        $('.speed-group').show();
        
        $('#QL_controls_speed_075').click( function(e) { e.preventDefault(); QL_player.set_speed(0.75); update_speed(); $('.speed-menu').hide();} );
        $('#QL_controls_speed_100').click( function(e) { e.preventDefault(); QL_player.set_speed(1.00); update_speed(); $('.speed-menu').hide();} );
        $('#QL_controls_speed_125').click( function(e) { e.preventDefault(); QL_player.set_speed(1.25); update_speed(); $('.speed-menu').hide();} );
        $('#QL_controls_speed_150').click( function(e) { e.preventDefault(); QL_player.set_speed(1.50); update_speed(); $('.speed-menu').hide();} );
        $('#QL_controls_speed_plus').click( function(e) { e.preventDefault(); QL_player.increase_speed(0.25); update_speed()} );
        $('#QL_controls_speed_minus').click( function(e) { e.preventDefault(); QL_player.decrease_speed(0.25); update_speed()} );

        var insideSpeedMenu = false;
        $('#QL_controls_speed_display').click(function(e){
            e.preventDefault();
            if($('.speed-menu').css('display') === 'none'){
                insideSpeedMenu = true;
                $('.speed-menu').show();
            }
        });
        $('.speed-menu').click(function(){
            insideSpeedMenu = true;
        })
        $(document).click(function(){
            if(!insideSpeedMenu) $('.speed-menu').hide();
            insideSpeedMenu = false;
        })


    }
  
    // Focus to play button
    $('button').first().focus();

    // Hand player to parent
    if(typeof(window.parent) === 'object'){
        window.parent.QL_player = QL_player;
    }

    // Show controls so we can tab into them
    QL_player.mediaelement_handle.showControls();

    // Add custom keyboard shortcuts
    ESC_KEY = 27;
    var quitAction = {keys: [ESC_KEY], action: function(player, media){
        if(typeof(window.parent) === 'object'){
            if(!player.isFullScreen){
                window.parent.$.fancybox.close();
            }
        }
    }};
    QL_player.mediaelement_handle.options.keyActions.push(quitAction);

    QUESTION_KEY = 191;
    var shortcutsAction = {keys: [QUESTION_KEY], action: function(player, media){
        toggleShortcuts();
    }};
    QL_player.mediaelement_handle.options.keyActions.push(shortcutsAction);

    var isCaptionsOn = false;
    C_KEY = 67;
    var captionsAction = {keys: [C_KEY], action: function(player, media){
        if(!isCaptionsOn){
            player.selectedTrack = player.tracks[0];
            player.captions.attr('lang', player.selectedTrack.srclang);
            player.displayCaptions();
            isCaptionsOn = true;
        }
        else{
            player.selectedTrack = null;
            player.captions.removeAttr('lang');
            player.displayCaptions();
            isCaptionsOn = false;
        }
    }};
    QL_player.mediaelement_handle.options.keyActions.push(captionsAction);

    PLUS_KEY = 187;
    var speedIncreaseAction = {keys: [PLUS_KEY], action: function(player, media){
        QL_player.increase_speed(0.25);
        update_speed();
    }};
    QL_player.mediaelement_handle.options.keyActions.push(speedIncreaseAction);

    MINUS_KEY = 189;
    var speedDecreaseAction = {keys: [MINUS_KEY], action: function(player, media){
        QL_player.decrease_speed(0.25);
        update_speed();
    }};
    QL_player.mediaelement_handle.options.keyActions.push(speedDecreaseAction);

}

function toggleShortcuts(){
    if($('.shortcuts_block').hasClass('isVisible')){
        $('.shortcuts_block').fadeOut();
        $('.shortcuts_block').removeClass('isVisible');
    }
    else{
        $('.shortcuts_block').fadeIn();
        $('.shortcuts_block').addClass('isVisible');
    }
}

$(document).ready(function(event){
    $('.shortcuts_link').click(function(event){
        toggleShortcuts()
        event.preventDefault();
    });
});

$(document).keydown(function(event){
    if(typeof(QL_player) === 'object' && typeof(QL_player.mediaelement_handle) === 'object'){
        QL_player.mediaelement_handle.showControls();
    }
});
