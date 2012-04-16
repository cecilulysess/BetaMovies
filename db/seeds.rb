# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# coding: utf-8
Movie.delete_all
efmovie = Movie.create( :title=>"EFTest", 
              :desc => "This is a 测试",
              :image => "http://upload.wikimedia.org/wikipedia/en/5/59/Ef_-_the_first_tale._screenshot.jpg",
#              :last_updated => DateTime.parse("2012-03-27"),
              :is_finished => true,
               )
Episode.create(
              :title => "720p",
              :link => "http://bbs.sends.cc/ulysess/eftest720p.mp4",
              :movie_id => efmovie.id
)
Episode.create(
              :title => "480P",
              :link => "http://bbs.sends.cc/ulysess/eftest480P.mp4",
              :movie_id => efmovie.id
)
naxienian = Movie.create(:title=>"那些年，我们一起追的女孩", 
              :desc => %{青春是一场大雨。即使感冒了，还盼望回头再淋它一次。<br/>
    青春更是一本书，一本读一遍就印象深刻，一本让你回味无穷的书。<br/>
    故事背景设定于1994年的彰化县精诚中学，亦是导演兼编剧的九把刀的母校。青春是一场大雨。即使感冒了，还盼望回头再淋它一次。人生就是不停的战斗，在还没有获得女神青睐时，左手永远都只是辅助！！！<br/>
    柯景腾（柯震东饰）的一群好友：爱耍帅却老是情场失意的老曹（敖犬饰），停止不了勃起所以叫勃起的勃起（鄢胜宇饰），想用搞笑致胜却总是失败的该边（蔡昌宪饰），胖界的夺爱高手阿和（赦绍文饰），为了共同喜欢的女孩——沈佳宜（陈妍希饰），不约而同从精诚中学国中部直升到高中部，一路都在进行他们从未完成的恋爱大作战。<br/>
    柯腾在一日上课时与勃起打手枪，结果被老师惩罚更换座位，坐到了沈佳宜前面。后来英文课时，沈佳宜没有携带课本，柯腾于是将自己的课本偷偷传给她，并站起来表示自己没携带课本，惹得老师一阵痛骂并体罚。沈佳宜为了感谢柯腾，还特地帮他出了“爱心考卷”，要柯腾好好用功。在过程中，两人不知不觉地逐渐喜欢上了彼此。<br/>
    毕业之后，联考放榜，柯腾考上了国立交通大学管科系，谢明和上东海大学企业管理系、廖英宏上逢甲大学资讯工程系、曹国胜上国立成功大学化工系，而沈佳宜在联考时因身体不适而表现失常，只考上了国立台北师范学院（今国立台北教育大学）感到十分难过沮丧。尽管身隔两地，柯腾每天晚上都会排队打公共电话，来关心沈佳宜。柯腾认为男生都要在女生面前表现自己最强的一面，于是举办了一场“自由格斗赛”。赛后，沈佳宜怪柯腾幼稚，不能理解为何柯腾要办比赛把自己弄伤；而柯腾则认为，沈佳宜不能理解他想在她面前表现出勇敢的一面，两人因此大吵一架。在大雨中，柯腾痛苦地放弃追求沈佳宜。<br/>
    大学毕业以后，柯腾考上东海大学研究所，并在过程中开始写小说。尽管两人未能成为恋人，不过友情却进一步升华，成为永远的好友。<br/>
    最后，大家都得到了各自的成长，拥有自己的未来。没有人哭泣、没有人懊恼，只有满心的祝福与胡闹。<br/>
    
    其实青春就是这样，总有一个得不到的人，总有一个错过的人，总有一个得到了却发现不是当初要找的那个人，剧中的新娘子是漂亮的，她身边的人也是合适的，真心祝福我们没得到的另一半吧，其实自己身边的人也是当年别人心中的天使。<br/>},
              :image => "http://img.shop.xunlei.com/pic/36/20136hbe.jpg",
#              :last_updated => DateTime.parse("2012-03-28"),
              :is_finished => true,
)
Episode.create(
              :title => "1080P",
              :link => "http://bbs.sends.cc/ulysess/naxienian1080P.mp4",
              :movie_id => naxienian.id
)
Movie.create( :title=>"《钢之炼金术师剧场版：叹息之丘的神圣之星》(Fullmetal Alchemist The Sacred Star of Milos)", 
              :desc => %{"《钢之炼金术师》堪称Bones这些年出品的最为亮眼的动画系列，
                从最初的年番TV到《香巴拉的征服者》剧场版结局补全，再到09年开启的《FA》重制，
                爱德华兄弟的找寻之旅牵动着无数追随者的目光。如今，漫画连载已画上句点，《钢炼》
                第二部剧场版则定于夏季登陆，究竟此次的故事会出自原作还是纯粹原创，尚处于保密状态。
                但从更换导演和人设这一举动来看，或许骨头社是希望避免《FA》给粉丝们造成的“阴影”。},
              :image => "http://i-7.vcimg.com/b4807aeab48664d4563e7b18ba5d0d72192235(100x100)/thumb.jpg",
#              :last_updated => DateTime.parse("2012-03-27"),
              :is_finished => true,
               )
         
Movie.create( :title=>"《夏目友人帐 第四季》(Natsume Yuujinchou Shi)", 
              :desc => %{玲子的孙子夏目贵志从外婆的遗物中得到了那些契约书所做成的“友人帐”，
                同样他也能看到不会显现在人前的物体。而且也和玲子一样成为了被周围人疏远的一员，
                被同龄人叫成“骗子”。 可是，作为唯一继承了玲子血统的他却做出了一个重要的决定：
                将玲子夺过来的妖怪们的名字一一归还。在这样的夏目的身边，开始聚集起各种各样的
                妖怪们…… 能看到妖怪的少年夏目贵志，与招财猫外表的妖怪猫咪老师一起，为大家讲
                述一个奇异、悲伤，怀念、令人感动的怪诞故事。片中充溢着细腻而动人的情感，
                再配上淡雅的音乐，让人在无意间为其喜为其忧，实在是一部好动画！},
              :image => "http://i-7.vcimg.com/405fbafb29b84b6b9a67880621d06df9139768(100x100)/thumb.jpg",
#              :last_updated => DateTime.parse("2012-03-27"),
              :is_finished => true,
               )
               
Movie.create( :title=>"《火影忍者 疾风传》(NARUTO Shippuuden)", 
              :desc => %{不知不觉《火影忍者》已经一路走了七年，鸣人从万年吊车尾的倒霉蛋慢慢地成
                长为能独党挡一面的忍者。从莽撞单纯的英雄主义男主角一步又一步地向忍道的达人迈进。
                为了友情，为了爱，为了被认可，为了自己的忍道，鸣人头也不回的奋斗了整整7年，以疾
                风的速度成长着。撒花庆贺的同时好消息自然不能少！明年早春火影动画也将回归漫画突入
                第二章，冗长乏味的TV动画，终于顺应民意走回“正途”。TV版消息满天飞的年末，
                先前不久海贼王剧场版第八弹的消息刚公布，火影TV版也紧随其后以“疾风传”赐名正式登场。},
              :image => "http://i-7.vcimg.com/1be09333b1e2093db4b1a4d3827ebcd1191022(120x120)/thumb.jpg",
#              :last_updated => DateTime.parse("2012-03-27"),
              :is_finished => false,
               )
               
dongzhiyidian = Movie.create( :title=>"东之伊甸", 
              :desc => "2010年11月22日星期一，日本各地遭到以10发导弹进行的恐怖攻击，不过奇迹似地没有任何人牺牲，这场逐渐被人遗忘的恐怖攻击被称为“疏忽的星期一”。3个月后，到美国毕业旅行的大学生森美咲在华盛顿哥伦比亚特区的白宫前被卷入纠纷，一位记忆丧失的全裸青年泷泽朗出现在他面前帮助她逃跑。意气相投的两人最后一起回到日本。不过，当天第11发导弹飞到了东京。这时，泷泽携带的手机传来自称为Juiz的女性的神秘讯息。
在寻找自己过去的过程中，泷泽朗接触到了别的Seleção，同时也渐渐得知自己的身世和导弹袭击的真相，以及Seleção们被迫参与的这场游戏的本质。",
              :image => "http://img.article.pchome.net/00/43/63/46//pic_lib/wm/07.jpg",
#              :last_updated => DateTime.parse("2012-03-29"),
              :is_finished => true,
               )
Episode.create(
              :title => "01",
              :link => "http://bbs.sends.cc/ulysess/dongzhiyidian/01.mp4",
              :movie_id => dongzhiyidian.id
)

Episode.create(
              :title => "02",
              :link => "http://bbs.sends.cc/ulysess/dongzhiyidian/02.mp4",
              :movie_id => dongzhiyidian.id
)
Episode.create(
              :title => "03",
              :link => "http://bbs.sends.cc/ulysess/dongzhiyidian/03.mp4",
              :movie_id => dongzhiyidian.id
)
Episode.create(
              :title => "04",
              :link => "http://bbs.sends.cc/ulysess/dongzhiyidian/04.mp4",
              :movie_id => dongzhiyidian.id
)
Episode.create(
              :title => "05",
              :link => "http://bbs.sends.cc/ulysess/dongzhiyidian/05.mp4",
              :movie_id => dongzhiyidian.id
)
Episode.create(
              :title => "06",
              :link => "http://bbs.sends.cc/ulysess/dongzhiyidian/06.mp4",
              :movie_id => dongzhiyidian.id
)
Episode.create(
              :title => "07",
              :link => "http://bbs.sends.cc/ulysess/dongzhiyidian/07.mp4",
              :movie_id => dongzhiyidian.id
)
Episode.create(
              :title => "08",
              :link => "http://bbs.sends.cc/ulysess/dongzhiyidian/08.mp4",
              :movie_id => dongzhiyidian.id
)
Episode.create(
              :title => "09",
              :link => "http://bbs.sends.cc/ulysess/dongzhiyidian/09.mp4",
              :movie_id => dongzhiyidian.id
)
Episode.create(
              :title => "10",
              :link => "http://bbs.sends.cc/ulysess/dongzhiyidian/10.mp4",
              :movie_id => dongzhiyidian.id
)
Episode.create(
              :title => "11",
              :link => "http://bbs.sends.cc/ulysess/dongzhiyidian/11.mp4",
              :movie_id => dongzhiyidian.id
)