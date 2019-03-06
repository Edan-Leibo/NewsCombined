## *Overview* ##
Nowadays, the news have become a central part of our lives. The information flow is ever-changing, fluid and enormous. The search after an interesting article that reflects our stance while containing fully fleshed out information which helps us understand it is both crucial and significant. Because of the multiple sources presenting similar subjects with different information and data from different perspectives, articles must be clustered with similar content in order to solve the exhausting search problem and aid us in getting the full picture of what interests us.

NewsCombined is a product which allows easy access to all the articles containing a similar subject taken from over 60 different sites (Google News, The BBC, Business Insider, BuzzFeed, etc.).
The product makes use of machine learning algorithms dissecting the articles' content and clustering them together in a simple and accessible manner for the user.

The system is based on three central steps:
1.	Data extraction/ collection phase – The system extracts articles from the newsAPI site which collects news articles from thousands of different blogs and sites – saving the data in a new file. Afterward, the system filters irrelevant articles and dissects the occurrence and frequency of words in a statistical manner.
2.	Learning phase – the system organizes the articles by groups of similar words used, while using NLP techniques and text classification like TF-IDF, KMEANS, and LDA CLUSTERING. Afterward, an article is randomly picked to represent the newly created article group.
3.	Interface – The system displays the article in a user-friendly GUI in an elegant manner. The application is divided into general categories allowing for a general sense of orientation. Every category contains a wide array of clustered articles.

_This overview presents the client-side only._


## :iphone: Usage :video_game: ##
Once the app loads, the hompage displays the news clusters within a certain category. At the top of the screen, the category name is shown, as well as a login button and a category menu button. The image and title of each cluster represents one article which was randomly chosen from the cluster. The number next to the chat icon indicates the number of massages that were sent regarding this topic, so that it is easy to distinguish the "hot" topics on the agenda.

<img src="https://i.imgur.com/WzpH1fJ.png" width="250">

Clicking the login icon (top right) enables the user to login to or disconnect from the system. User authentication is required for commenting or hitting like/dislike buttons (other services are available without login). Furthermore, through this screen, the user can upload a profile photo and change it at any given time.

<img src="https://i.imgur.com/lbSwnXA.png" width="250">

Once the user has logged in, clicking the chat icon will open the chat screen which allows the user to comment and discuss topics with other users around the world.

<img src="https://i.imgur.com/0EqzVcG.png" width="250">

Clicking the menu icon (top left on hompage) opens the list of available categories in the app. Choosing a category, immediately switches the hompage display to article clusters of the chosen category.

<img src="https://i.imgur.com/GCnoWBd.png" width="250">

Clicking on of the clusters, opens the cluster page which displays all the articles within the cluster, taken from different and versatile sources. The news source and the reporter's name are indicated for each article. Like and dislike buttons indicate the popularity and controversy of each article. Clicking one of the icons will increase the likes/dislikes count. As we strive to fight the "fake news" epidemic, this indication helps the user to understand which articles represent the opinion of the majority, with a swift glance.    

<img src="https://i.imgur.com/vtfrXqy.png" width="250">

Finally, clicking an article, transfers the user to an embedded browser, where the full article is available directly through the website that published the article, but still within the framework of the NewCombined app.

<img src="https://i.imgur.com/I4vJ2Qb.png" width="250">

Clicking the "back" button on each screen, returns the user to the previous screen, until he reaches the cluster hompage.

## :hammer: App Architecture :construction_worker: ##

The NewsCombined app is based on MVC architecture. It containes a unit, developed according to an Observer pattern, which is responsible for syncronizing the local SQLite database with the remote databse located in Firebase. This unis exists in the Model layer and contains a component with the sole purpose of recieving notifications, regarding CRUD operations, from the database.

In order to improve the preformance of the system, upon the arrival of such notifications, the system checks the timestamp of the data and updates the local SQLite based database. As a result, the system we've created has substantially low traffic, and is able to operate without network connection (the app would simply retrieve the data stored in the local database at the that moment).

Additionaly, we provided the system with unit tests which examine the internal modules.

**_Developed by Edan Leibovitz :man: & Adam Yablonka :man:_**

**_edan.leibo@gmail.com_**

**:smile: Feel free to use it at will with attribution of source. :bowtie:**

**:astonished: If you find any typos, errors, inconsistencies etc. please do not hesitate to contact me for any issue. :mailbox:**

