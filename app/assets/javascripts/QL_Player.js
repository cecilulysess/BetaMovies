
/** function QL_Player(parameters)
  * QL Player constructor
  *
  * @param string suffix - suffix for element IDs
  * @param int width - width of player
  * @param int height - height of player
  * @param Array cue_points - array of cue points. Each cue point is a hash that must
  *                           contain a time element indicating when the cue point should be triggered.
  * @param cue_point_handler - function cue_point_handler(triggered_cue_points) { ... }
  * @param Object sources - associative array of video type => url
  * @param Object subtitles - associative array of subtitle language => url
  *
  * @return void
  *
  * Notes:
  * this.elements - can access player_container, video_element
        Layout:

        <div id="QL_player_container_suffix">
            <div id="mep_0">...
            </div>

            <div class="QL_overlay_scale">...
            </div>
            <div class="QL_overlay_scale">...
            </div>
            ...
            <div class="QL_overlay_noscale">...
            </div>

        </div>

        */
function QL_Player(parameters) {
    /*
        parameters: {
            suffix:
            width:
            height:
            cue_points:
            cue_point_handler:
            install_success_handler:
            sources: {
               "video/mp4": "http://path/to/myvideo.mp4",
               "video/webm": "http://path/to/myvideo.webm"
               "video/ogg": "http://path/to/myvideo.ogg",
            }
            subtitles: {
                "日本語": "http://path/to/japanese.srt",
                   "한국어": "http://path/to/korean.srt",
                "中文": "http://path/to/chinese.srt",
            }
        }
        */

    /** function initialize_parameters(parameters)
      * Used internally to initialize this object's parameters
      *
      * @return void
      */
    this.initialize_parameters = function(parameters) {
        var required_parameters = ['suffix','width','height','cue_points','cue_point_handler','sources','subtitles'];
        var param_name, i;
        for (i=0;i<required_parameters.length;i++) {
            param_name = required_parameters[i];
            if (typeof parameters[param_name] == "undefined") {
                alert(param_name + ' not set');
                return false;
            }
            this[param_name] = parameters[param_name];
        }

        // Optional - install_success_handler
        if (typeof parameters["install_success_handler"] == "undefined"){
            parameters["install_sucess_handler"] = function() {};
        }
        this["install_success_handler"] = parameters["install_success_handler"];

        this.aspect_ratio = this.width / this.height;
        this.elements = {};
        this.mediaelement_handle = null; // For abusing MediaElement internals
        this.mediaelement_media = null;  // For accessing the (external) HTML5/MediaElement API
        this.cue_points_installed = false;
        return true;
    }

    /** function initialize()
      * Creates (but does not install) the elements for the QL player
      *
      * @return void
      */
    this.initialize = function() {
        var QL_player_container;
        var QL_video_element;
        var QL_id;
        var type;

        QL_id = this.suffix;


        // Get elements by ID
        QL_player_container = $('#QL_player_container_' + QL_id);
        QL_video_element = $('#QL_video_element_' + QL_id);

        // Set it up so canvas and overlay are at exactly the same position
        QL_player_container.css('position', 'absolute');
        

        // Have to set the width and height attributes on <video> elements (instead of setting the CSS width and height attributes)
        QL_video_element.attr('width', this.width).attr('height', this.height);

        this.elements.player_container = QL_player_container;
        this.elements.video_element = QL_video_element;
        this.is_fullscreen = false;
    };

    /** function install_at(element)
      * Installs the player on the page by replacing the given element with the player
      * YF: This doesn't actually do any replacing any more, but just calls MediaElement.
      *
      * @param DOMElement/jQuery element - element to replace
      *
      * @return void
      */
    this.install_at = function (element, opts) {

        // Bind local scope
        l_QL_player = this;
        
        // Enable fullscreen only if we're not on mobile
        var mediaelementFeatures = ['playpause', 'progress', 'current', 'duration', 'tracks', 'volume'];
        if(!(mejs.MediaFeatures.isAndroid ||
                mejs.MediaFeatures.isBustedAndroid ||
                mejs.MediaFeatures.isiOS ||
                mejs.MediaFeatures.isiPad ||
                mejs.MediaFeatures.isiPhone)){
            mediaelementFeatures.push('fullscreen');
        }

        // Set up options
        var mediaelement_opts = {
            //alwaysShowControls: true,
            videoWidth: this.width,
            videoHeight: this.height,
            startVolume: 1.0,
            loop: false,
            enableAutoSize: false,
            features: mediaelementFeatures,
            translationSelection: false,
            alwaysShowControls: true,

            success: function(media, DOMnode, mediaelement) {

                // Where media gives access to the (external) MediaElement API / HTML5 API
                l_QL_player.mediaelement_media = media;
                
                // Disable fullscreen in some cases
                if(media.pluginType === 'flash' && mejs.MediaFeatures.isFirefox === true){
                    $('.mejs-fullscreen-button').hide();
                }

                // If our video type looks like Flash, destroy all the video elements on the page
                if(media.pluginType === 'flash'){
                    $('video').remove();
                }

                //setTimeout(function() {
                    //l_QL_player.mediaelement_handle.enterFullScreen(true);
                //}, 200);

                // Install cue points
                media.addEventListener('loadedmetadata', function(){l_QL_player.install_cue_points.call(l_QL_player)});

                window.previous_time = 0;

                // previousTime is a variable within this context only
                // This handler is called on the timeupdate Itsp
                // event keeps track of the previousTime
                // so it knows when to trigger a cue point
                // (when previous_time is before the cue time but currentTime is after
                //  and a small amount of time has elapsed between the two)
                // The handler creates an array of all triggered cue points, and
                // passes it to the cue point handler if present.
                var triggerCuePoints = function(){
                    if(!l_QL_player.mediaelement_media.paused){
                        var i;
                        var cue_point_time;
                        var triggered_cue_points;
                        var currentTime = l_QL_player.mediaelement_media.currentTime;
                        var timeDelta = currentTime - this.previous_time;

                        if (timeDelta > 0 && timeDelta < 1) {

                            triggered_cue_points = new Array();

                            for (i = 0; i < l_QL_player.cue_points.length; i++) {
                                cue_point_time = l_QL_player.cue_points[i].time;
                                if ((this.previous_time < cue_point_time) && (currentTime >= cue_point_time)){
                                    triggered_cue_points.push(l_QL_player.cue_points[i]);
                                }
                            }

                            if (triggered_cue_points.length > 0 && l_QL_player.cue_point_handler !== null){
                                l_QL_player.cue_point_handler(triggered_cue_points);
                            }

                        }

                        this.previous_time = currentTime;
                    }
                }
                setInterval(triggerCuePoints, 100);

                var clipCuePoints = function(){
                    var margin = 1.0;
                    var maxTime = l_QL_player.mediaelement_media.duration - margin;
                    for (i = 0; i < l_QL_player.cue_points.length; i++) {
                        if(l_QL_player.cue_points[i].time > maxTime){
                            l_QL_player.cue_points[i].time = maxTime
                        }
                    }
                }

                media.addEventListener('loadedmetadata', clipCuePoints);

                l_QL_player.install_success_handler(media, DOMnode, mediaelement);
            }

        };

        //Override with client-supplied options
        for(key in opts){
            if(opts.hasOwnProperty(key)){
                mediaelement_opts[key] = opts[key];
            }
        }

        // And call mediaelementplayer on the <video> tag
        // Also get the handle of the media element player (which may be <video> or Flash, etc)
        this.mediaelement_handle = new mejs.MediaElementPlayer(this.elements.video_element, mediaelement_opts);
        
        l_QL_player.refresh_overlay();

        var prependCallback = function(original, toPrepend){
            return function(){
                var that = this;
                toPrepend.apply(that, arguments);
                return original.apply(that, arguments);
            };
        };

        var appendCallback = function(original, toAppend){
            return function(){
                var that = this;
                var returnVal = original.call(that, arguments);
                toAppend.call(that, arguments);
                return returnVal;
            }
        }

        var that = this;
        this.mediaelement_handle.enterFullScreen = prependCallback(this.mediaelement_handle.enterFullScreen, function(){
            $('body').addClass('fullscreen-body');
            that.elements.player_container.removeClass('ql_container_partscreen').addClass('ql_container_fullscreen');
            $('#QL_controls').hide()
            if(typeof(window.parent) === 'object' && typeof(window.parent.enterFullScreen) === 'function'){
                window.parent.enterFullScreen();
            }
        });

        this.mediaelement_handle.enterFullScreen = appendCallback(this.mediaelement_handle.enterFullScreen, function(){
            that.is_fullscreen = true;
            that.refresh_overlay();
            $(window).resize();
        });

        this.mediaelement_handle.exitFullScreen = prependCallback(this.mediaelement_handle.exitFullScreen, function(){
            $('body').removeClass('fullscreen-body');
            that.elements.player_container.removeClass('ql_container_fullscreen').addClass('ql_container_partscreen');
            $('#QL_controls').show()
            if(typeof(window.parent) === 'object' && typeof(window.parent.exitFullScreen) === 'function'){
                window.parent.exitFullScreen();
            }
        });

        this.mediaelement_handle.exitFullScreen = appendCallback(this.mediaelement_handle.exitFullScreen, function(){
            that.is_fullscreen = false;
            that.refresh_overlay();
        });

        var that = this;

        $(window).resize(function() {
            // Refresh position and size of quiz overlay
            if(that.is_fullscreen) {
                that.refresh_overlay();
            }
        });


    }; // install_at

    /** function install_cue_points()
      * "Installs" cue points on the total time rail on the MediaElement controls
      * (WARNING: abuses MediaElement by reaching in into its internals)
      *
      * @return void
      */
    this.install_cue_points = function() {
        var i;
        var time_total_rail;
        var percent;

        if (this.cue_points_installed){
            return;
        }
        this.cue_points_installed = true;

        time_total_rail = this.mediaelement_handle.controls.find('.mejs-time-total');

        for (i=0;i<this.cue_points.length;i++) {
            percent = (this.cue_points[i].time / this.mediaelement_media.duration);
            percent = Math.floor(percent * 10000) / 100 + '%'; // Give to 2dp
            time_total_rail.append( $('<div></div>').addClass('mejs-cuepoint').css('position', 'absolute').css('left', percent) );
        }
    };

    /** function set_speed(speed)
      * Set the video speed
      *
      * @param double speed - target speed
      *
      * @return void
      */
    this.is_set_speed_enabled = function(){
        if(typeof(this.mediaelement_media) === 'object'
                && this.mediaelement_media !== null
                && typeof(this.mediaelement_media.playbackRate) === 'number'
                && this.mediaelement_media.playbackRate > 0){
            return true;
        }
        else{
            return false;
        } 
    }

    this.set_speed = function(speed) {
        if(this.is_set_speed_enabled()) this.mediaelement_media.playbackRate = speed;
    }

    this.get_speed = function(speed) {
        if(this.is_set_speed_enabled()) return this.mediaelement_media.playbackRate;
        else return 1;
    }

    this.increase_speed = function(deltaSpeed){
        var minSpeed = 0.50;
        var maxSpeed = 2.00
        var newSpeed = QL_player.get_speed() + deltaSpeed;
        if(newSpeed < minSpeed) newSpeed = minSpeed;
        if(newSpeed > maxSpeed) newSpeed = maxSpeed;
        QL_player.set_speed(newSpeed);
    }

    this.decrease_speed = function(deltaSpeed){
        this.increase_speed(-deltaSpeed);
    }

    /** function refresh_overlay()
      * Update the size of the overlay (is called when entering/exiting full screen, or when the window is resized)
      *
      * @return void
      */
    this.refresh_overlay = function() {
        var new_height, new_width;
        var scale;
        var temp_height;
        var controlsHeight = 30;

        // Preserve aspect ratio
        new_height = this.mediaelement_handle.container.height() - controlsHeight;
        new_width = this.mediaelement_handle.container.width();

        if (new_height * this.aspect_ratio > new_width){
            new_height = new_width / this.aspect_ratio;
        }
        if (new_width / this.aspect_ratio > new_height){
            new_width = new_height * this.aspect_ratio;
        }

        new_width = Math.floor(new_width);
        new_height = Math.floor(new_height);

        // Get scale factor, so we can scale the quiz
        scale = new_width / this.width;

        
        // Scale overlays that require scaling
        var scaleOverlays = this.elements.player_container.children('.QL_overlay.QL_scale');

        scaleOverlays.css('position', 'absolute');
        scaleOverlays.css('left', (this.mediaelement_handle.container.width() - new_width) / 2);
        scaleOverlays.css('top', (this.mediaelement_handle.container.height() - controlsHeight - new_height) / 2);
        scaleOverlays.css('width', 960);
        scaleOverlays.css('height', 540);

        scaleOverlays.css('-ms-transform', 'scale('+ scale+')');
        scaleOverlays.css('-moz-transform', 'scale('+ scale+')');
        scaleOverlays.css('-webkit-transform', 'scale('+ scale+')');
        scaleOverlays.css('-o-transform', 'scale('+ scale+')');
        if(mejs.MediaFeatures.isIE){
            scaleOverlays.css('zoom', scale);
        }

        scaleOverlays.css('-ms-transform-origin', '0 0');
        scaleOverlays.css('-moz-transform-origin', '0 0');
        scaleOverlays.css('-webkit-transform-origin', '0 0');
        scaleOverlays.css('-o-transform-origin', '0 0');

        // Just resize overlays that don't require scaling
        var noscaleOverlays = this.elements.player_container.children('.QL_overlay.QL_noscale');
        
        noscaleOverlays.css('position', 'absolute');
        noscaleOverlays.css('left', 0);
        noscaleOverlays.css('top', 0);
        noscaleOverlays.css('width', this.mediaelement_handle.container.width());
        noscaleOverlays.css('height', this.mediaelement_handle.container.height() - controlsHeight);

    };

    this.add_overlay = function(overlay, scale){
        // Clean parameters
        var overlay = $(overlay);
        if(typeof(scale) === 'undefined') scale = true;

        // Add classes
        overlay.addClass('QL_overlay');
        if(scale) overlay.addClass('QL_scale');
        else overlay.addClass('QL_noscale');

        // Append to DOM
        this.elements.player_container.append(overlay);
        this.refresh_overlay();

    }


    if (!this.initialize_parameters(parameters)){
        return;
    }
    this.initialize();

}
