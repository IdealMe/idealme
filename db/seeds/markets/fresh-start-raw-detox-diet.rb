course = Course.order('id DESC').limit(1).last

section = Section.create!(:name => 'Fresh Start! Raw Detox Diet', :position => 1)
course.sections << section

lecture = Lecture.create!(:name => 'Introductory Guide', :position => 1, :description => '')
section.lectures << lecture

section = Section.create!(:name => 'Before You Start', :position => 2)
course.sections << section

lecture = Lecture.create!(:name => 'Introduction', :position => 1, :description => '<p>Welcome to your raw-detox diet! This introductory guide gives you the information on how and why you should go raw. Find out what?s wrong with your current diet and how you can easily transition into a much healthier way of eating.</p>')
section.lectures << lecture

lecture = Lecture.create!(:name => 'First Step FAQ', :position => 2, :description => '<p>Just getting started? Read over the First Step FAQs for all the answers to your most frequently asked raw detox-diet questions in addition to the first 5 steps you must take as a beginner. From restaurants orders to tea, coffee and alcohol, all the answers you need to know can be found here.</p>')
section.lectures << lecture

lecture = Lecture.create!(:name => 'Grocery List', :position => 3, :description => '<p>Yes, raw food grocery shopping is really this easy! The Grocery List lays out all the basics you?ll want to stock up on to enjoy delicious raw snacks and meals regularly while on your Start Fresh! Raw-Detox Diet.</p>')
section.lectures << lecture

section = Section.create!(:name => 'Advanced Nutritional Materials', :position => 3)
course.sections << section

lecture = Lecture.create!(:name => 'Advanced Raw Knowledge', :position => 1, :description => '<p>Learn more about your internal pH balance as well as the truth behind organically labeled foods in this Advanced Raw Knowledge guide. Discover what the term ?detox? really means, and further understand digestion and diet diversification. Finally, learn how to combine different food groups for winning meal combinations.</p>')
section.lectures << lecture

lecture = Lecture.create!(:name => 'Tips Beyond Week One', :position => 2, :description => '<p>Think you?re advanced enough to call yourself a raw foodie? Make sure to read over this full list of advanced raw detox-diet tips found right here in the Tips Beyond Week One guide. Get the necessary advice on choosing vitamins, distilling water, using fruit dehydrators plus many more tips for the experienced raw foodie!</p>')
section.lectures << lecture

section = Section.create!(:name => 'Recipes', :position => 4)
course.sections << section

lecture = Lecture.create!(:name => '7 Breakfasts', :position => 1, :description => '<p>Start your day off with one of the hearty, healthy raw breakfast recipes from the 7 Breakfasts guide. Take your pick from raw foodie favorites like "The Open-Faced Breakfast Sandwich," "The Orange Chia Breakfast Pudding" or "The Banana Almond Smoothie."</p>')
section.lectures << lecture

lecture = Lecture.create!(:name => '7 Lunches', :position => 2, :description => '<p>Here are your 7 super simple lunch recipes that require little to no prep time. Enjoy filling and flavorful raw lunches such as the "Avocado Mango Broccoli Salad," "Green Romaine Soup" or "Asparagus Soup," all found inside the 7 Lunches raw recipe guide.</p>')
section.lectures << lecture

lecture = Lecture.create!(:name => '7 Dinners', :position => 3, :description => '<p>Your week\'s worth of raw detox diet dinners can be found right here! Choose from 7 tasty dishes including but not limited to "The South-western Chipotle Salad," "Raw Sushi," and "Tarragon Pine Nut and Spinach Salad." These dinner dishes are perfect for week one of your Start Fresh! Raw-Detox Diet.</p>')
section.lectures << lecture

lecture = Lecture.create!(:name => '7 Juice & Desserts', :position => 4, :description => '<p>Looking for a sweet treat after a scrumptious raw meal? Try one of the seven juice and dessert recipes within this guide, like "The Daily Detox Juice," "Easy Almond Milk," or "Chocolate Mint Cheesecake." Yum!</p>')
section.lectures << lecture

section = Section.create!(:name => 'Bonus', :position => 5)
course.sections << section

lecture = Lecture.create!(:name => '36 Bonus Recipes', :position => 1, :description => '<p>From breakfast smoothies to dinners, side dishes and desserts, this recipe guide provides you with over 12 days worth of delicious raw food meals. The 36 Bonus Recipes range in prep time and ingredients for a well-balanced, nutritious and delicious raw detox-diet.</p>')
section.lectures << lecture

lecture = Lecture.create!(:name => 'Juicing Guide', :position => 2, :description => '<p>Find out everything you need to know when it comes to juicing! This guide details the benefits of juicing, the many different types of juicers, how to store your juices, plus a complete list of produce you can juice. You can also learn how to juice for fiber, juice for protein and juice for fasting by simply referencing this guide.</p>')
section.lectures << lecture

lecture = Lecture.create!(:name => 'Nutrition Guide', :position => 3, :description => '<p>The Nutrition Guide provides a full breakdown of the fruits, vegetables, nuts and seeds you will consume when on your Start Fresh! Raw-Detox Diet. Easily determine the mineral and vitamin content contained in over 100 different types of food for easy raw-detox diet maintenance.</p>')
section.lectures << lecture

lecture = Lecture.create!(:name => 'Bonus Worksheets Days 1-7', :position => 4, :description => '<p>The Bonus Worksheets are your very own progress reports. These quick daily reference sheets let you record your daily meals as well as your weight and mood so you can measure your progress throughout your first week on the Start Fresh! Raw-Detox Diet.</p>')
section.lectures << lecture

lecture = Lecture.create!(:name => 'Bonus Worksheets Days 7+', :position => 5, :description => '<p>Continue to use these Bonus Worksheets to chart your progress on the raw food detox-diet after week one. Print as many copies as you want and continue filling out your daily meals, moods and weight to stay mindful of your transition into the raw food lifestyle.</p>')
section.lectures << lecture