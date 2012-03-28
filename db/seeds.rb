# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# coding: utf-8
Movie.delete_all
Movie.create( :title=>"EFTest", 
              :description => "This is a 测试",
              :image_url => "http://upload.wikimedia.org/wikipedia/en/5/59/Ef_-_the_first_tale._screenshot.jpg",
              :last_updated => DateTime.parse("2012-03-27"),
              :is_finished => true,
               )
Movie.create( :title=>"《钢之炼金术师剧场版：叹息之丘的神圣之星》(Fullmetal Alchemist The Sacred Star of Milos)", 
              :description => %{"《钢之炼金术师》堪称Bones这些年出品的最为亮眼的动画系列，
                从最初的年番TV到《香巴拉的征服者》剧场版结局补全，再到09年开启的《FA》重制，
                爱德华兄弟的找寻之旅牵动着无数追随者的目光。如今，漫画连载已画上句点，《钢炼》
                第二部剧场版则定于夏季登陆，究竟此次的故事会出自原作还是纯粹原创，尚处于保密状态。
                但从更换导演和人设这一举动来看，或许骨头社是希望避免《FA》给粉丝们造成的“阴影”。},
              :image_url => "http://i-7.vcimg.com/b4807aeab48664d4563e7b18ba5d0d72192235(100x100)/thumb.jpg",
              :last_updated => DateTime.parse("2012-03-27"),
              :is_finished => true,
               )
         
Movie.create( :title=>"《夏目友人帐 第四季》(Natsume Yuujinchou Shi)", 
              :description => %{玲子的孙子夏目贵志从外婆的遗物中得到了那些契约书所做成的“友人帐”，
                同样他也能看到不会显现在人前的物体。而且也和玲子一样成为了被周围人疏远的一员，
                被同龄人叫成“骗子”。 可是，作为唯一继承了玲子血统的他却做出了一个重要的决定：
                将玲子夺过来的妖怪们的名字一一归还。在这样的夏目的身边，开始聚集起各种各样的
                妖怪们…… 能看到妖怪的少年夏目贵志，与招财猫外表的妖怪猫咪老师一起，为大家讲
                述一个奇异、悲伤，怀念、令人感动的怪诞故事。片中充溢着细腻而动人的情感，
                再配上淡雅的音乐，让人在无意间为其喜为其忧，实在是一部好动画！},
              :image_url => "http://i-7.vcimg.com/405fbafb29b84b6b9a67880621d06df9139768(100x100)/thumb.jpg",
              :last_updated => DateTime.parse("2012-03-27"),
              :is_finished => true,
               )
               
Movie.create( :title=>"《火影忍者 疾风传》(NARUTO Shippuuden)", 
              :description => %{不知不觉《火影忍者》已经一路走了七年，鸣人从万年吊车尾的倒霉蛋慢慢地成
                长为能独党挡一面的忍者。从莽撞单纯的英雄主义男主角一步又一步地向忍道的达人迈进。
                为了友情，为了爱，为了被认可，为了自己的忍道，鸣人头也不回的奋斗了整整7年，以疾
                风的速度成长着。撒花庆贺的同时好消息自然不能少！明年早春火影动画也将回归漫画突入
                第二章，冗长乏味的TV动画，终于顺应民意走回“正途”。TV版消息满天飞的年末，
                先前不久海贼王剧场版第八弹的消息刚公布，火影TV版也紧随其后以“疾风传”赐名正式登场。},
              :image_url => "http://i-7.vcimg.com/1be09333b1e2093db4b1a4d3827ebcd1191022(120x120)/thumb.jpg",
              :last_updated => DateTime.parse("2012-03-27"),
              :is_finished => false,
               )