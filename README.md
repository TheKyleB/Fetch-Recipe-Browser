FetchRecipeBrowser - Kyle Brownell

### Summary:

Here are screenshots of my application in action:

Recipe List

<img src="https://github.com/TheKyleB/Fetch-Recipe-Browser/blob/main/Recipe%20List.png" alt="Recipe List" width="200"/>


Searching Recipes

<img src="https://github.com/TheKyleB/Fetch-Recipe-Browser/blob/main/Recipe%20List.png" alt="Searching Recipes" width="200"/>


Filtering Recipes

<img src="https://github.com/TheKyleB/Fetch-Recipe-Browser/blob/main/Recipe%20List%20Filtering.png" alt="Filtering Recipes" width="200"/>


Recipe Details

<img src="https://github.com/TheKyleB/Fetch-Recipe-Browser/blob/main/Recipe%20Details.png" alt="Recipe Details" width="200"/>


Empty Search

<img src="https://github.com/TheKyleB/Fetch-Recipe-Browser/blob/main/Recipe%20List%20Empty.png" alt="Empty Search" width="200"/>


### Focus Areas:
The largest focus I had for the application was having the user be able to filter the recipes. I added a search bar, a sort by country/name toggle, and a way to filter out cuisines. I felt like with the limited information provided by the JSON data, the most important part was helping the user find the recipes they want to try making the most.
  
### Time Spent:
While I am submitting my project about a month after receiving it, I only spent about a weeks worth of time developing the application. As I mentioned to Katie Crona, I have been really busy with helping my parents with both preparing to move houses and with selling their current one. In the limited time I had avaliable, I also did not have frequent access to my fathers Mac Mini which is what I used for this project. 

The development timeline with the time not spent working on it took roughly a full week, the breakdown of my time spent was: 1 day (~7-8 hours) of trying to run Xcode on a virtual machine before swapping to my fathers Mac Mini, 1 hour making a wireframe mock up of what I envisioned the app to look and functin like, which I sent to some friends from my University for feedback. 3 hours refamiliarizing myself with Xcode (had been some time since I last used Swift and when I did I used storyboards, so I followed a tutorial provided by Apple to get used to SwiftUI). Finally I had 4 separate instances of 4-6 hour work sessions where in the first one I set up the layout of the application (I was still a bit unfamiliar with SwiftUI), second session I got the JSON data pulled from the url, third session I figured out the sorting/filtering/searching of the list of recipes, and the fourth session I made sure my app met the project requirements while also adding some unit tests to test the JSON data fetching. 

### Trade-offs and Decisions:
As mentioned in the focus area section, I spent more time on the ability to filter/search for recipes than the visual layout of the application. Also I decided to have a "second screen" (which was just another view in a ZStack to be displayed on top of the initial screen) to give a detailed view of the selected cuisine, however there really isn't that much information that needs to be displayed so it feels kind of empty, however if more information were to ever be added to the JSON data, there is space ready to accommodate it. 
  
### Weakest Part of the Project:
I think the weaksest part of my project is the style of the application. This was my first time using SwiftUI for development and so I was not very familiar with the different stylistic options avaliable for me when creating buttons, text, images, and other visual aspects of the app. I don't think it looks bad but if I was more familiar with SwiftUI I believe I could have made it look more cohesive and cleaner.

### Additional Information:
The image caching is handled by Apples newish LazyVStack view which loads in the contents dynamically as rows are needed, when scrolling through the list of recipes you can see on the network usage it spikes briefly as it loads the new images for each row. I believe I read that the cached data is only freed if the application uses a lot of system memory and since it is quite a small application I think it wont ever unload the images from the cache, which for this small application I felt was not a problem.
