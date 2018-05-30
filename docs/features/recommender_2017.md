# Business Objective
To recommend applications to users that they might find useful in their everyday objectives    

Original Ticket: https://github.com/aml-development/ozp-backend/issues/193

## Requirements
* Hardware and software requirements should not add cost or dependencies
* Solution shall work in development and production environments
* Solution shall be a hybrid solution composed of content and user based recommendation
* Recommendation Results shall be returned in less than three second
  * Recomputing the results will make sure requirement will be meet


## Researched Solutions
### DSSTNE
Designed to create and run recommendation models using minimal input and output, but numerous connected layers in between.  Emphasizes on speed and scaling.

**Pros**    
* Faster than other deep learning libraries.
* Able to solve recommendations problems in a fast manner.

**Cons**    
* Multiple dependencies need to be installed.
* Team would need time to learn. (DEEP LEARNING CURVE)
* DSSTNE relies on multiple GPU's to perform optimally, though we do not have the ability to use multiple GPU's.
* Python support currently unavailable (but on the way).

### MXNET
MXNet is a deep learning framework designed for both efficiency and flexibility, allows you to define, train, and deploy deep neural networks on a wide array of devices, from cloud infrastructure to mobile devices.

**Pros**    
* Portable (works on all major os, and programming language, julia, python, scala, r)
* Efficient (Takes less memory)
* Scalable (Ability do work across many GPUs and Machines)

**Cons**    
* Learning Curve  
* Need a lot of data (takes millions of records for learning
* Requires a gpu

### PredictionIO
An open source machine learning framework for developers, and users.  Queries predictive results using RES API's.

**Pros**    
* Open Source
* Has multiple Recommender templates available for use
* Python support

**Cons**    
* All of the Recommender templates are done in Scala, which is not currently used by the team
* Bundled with Elasticsearch

### Elasticsearch
Can be customize to use user inputs to determine recommendations based on previous searches.
Choosing the wrong method can have disastrous consequences for the quality of recommendations.
https://www.elastic.co/guide/en/elasticsearch/reference/2.4/search-aggregations-bucket-significantterms-aggregation.html

**Pros**    
* Use statistics without personalization with Elasticsearch Aggregations to create profiles
* Collaborative Filtering – The theory of guessing interesting items from similar items or similar users
* Customizable based on implementation techniques
* There is a More Like This API which allows to get documents

**Cons**
* Need to build The system
* Higher possibility of error in implementation

### Neo4j
Uses real time results using a visual graph relation to create a recommendation.

**Pros**    
* Graph interface and can be visual and understandable
* Analysis on nodes and lines

**Cons**
* Needs to use a JVM Engine and is Java based.  So as Java versions change need to verify that it can work with the infrastructure.
* Each engine is created to perform a recommendation
* Data is represented in Graphs and how data is connected to each node to node.  They relationships are between the nodes not the data.
* Might need to use GraphAware add-on
* Queries might take some time to develop

### Crab
Recommender systems in Python, can construct a customized recommender system from a set of algorithms

**Pros**    
* Python
* Recommender Algorithms: User-Based Filtering and Item-Based Filtering
* License: Open source, commercially usable

**Cons**
* Learning Curve
* Single Machine Processing

## Mock up
Requirement came from https://github.com/ozone-development/ozp-documentation/wiki/Iteration-53#uiux

### Center Front page
![](https://raw.githubusercontent.com/ozone-development/ozp-documentation/master/mockups/marketplace/Center_Recommended.PNG)

### Center Search page
![](https://raw.githubusercontent.com/ozone-development/ozp-documentation/master/mockups/marketplace/Center_smartsearch_recommendation.PNG)

## Recommendation Engine Principles
http://people.cs.vt.edu/~ramakris/papers/receval.pdf    
"""
- Recommendation is an indirect way of bringing people together. As we will
  discuss recommendation algorithms, especially collaborative filtering, exploit connections
  between users and artifacts.
- Recommendation, as a process, should emphasize modeling connections
  from people to artifacts, besides predicting ratings for artifacts. In many situations,
  users would like to request recommendations purely based on local and global
  constraints on the nature of the specific connections explored.
- Recommendations should be explainable and believable.
- Recommendations are not delivered in isolation, but in the context of an
  implicit/explicit social network.
"""


## Approach
### Scheduled Offline Batch
- Add Recommendation Model to models.py file (This model is used to store the results of the script/program that computes recommendations).

``` python
class RecommendationsEntry(models.Model):
    """
    A Listing that a user (Profile) has in their 'application library'/bookmarks
    """
    target_profile = models.ForeignKey(
        'Profile', related_name='recommendations_entries')
    listing = models.ForeignKey(
        'Listing', related_name='recommendations_entries')
    score = models.CharField(max_length=255, blank=True, null=True)

    def __str__(self):
        return '{0!s}:{1!s}:{2!s}'.format(self.folder, self.owner.user.username,
                             self.listing.title)

    def __repr__(self):
        return '{0!s}:{1!s}:{2!s}'.format(self.folder, self.owner.user.username,
                             self.listing.title)

    class Meta:
        verbose_name_plural = "recommendations entries"
```
- Add recommended listing to storefront endpoint (This endpoint is used to show the users the results of the computation of the recommendation script/program)

``` diff
diff --git a/ozpcenter/api/storefront/model_access.py b/ozpcenter/api/storefront/model_access.py
index 85418d1..277150b 100644
--- a/ozpcenter/api/storefront/model_access.py
+++ b/ozpcenter/api/storefront/model_access.py
@@ -21,8 +21,16 @@ def get_storefront(username):

     NOTE: think about adding Bookmark status to this later on
     """
-    user = models.Profile.objects.get(user__username=username)  # flake8: noqa TODO: Is Necessary? - Variable not being
+    profile = models.Profile.objects.get(user__username=username)  # flake8: noqa TODO: Is Necessary? - Variable not bei
     try:
+        # get recommended listing for owner
+        recommended_listings = models.RecommendationsEntry.objects.filter(target_profile=profile,
+                                                                         listing__is_enabled=True,
+                                                                         approval_status=models.Listing.APPROVED
+                                                                         is_deleted=False).order_by('-score').values(
+                                                                             'listing')[:12]
+        # Ensure that the Listing are viewable by the current user
+
         # get featured listings
         featured_listings = models.Listing.objects.for_user(
             username).filter(
@@ -51,6 +59,7 @@ def get_storefront(username):
         most_popular_listings = serializers.ListingSerializer.setup_eager_loading(most_popular_listings)

         data = {
+            'recommended': recommended_listings,
             'featured': featured_listings,
             'recent': recent_listings,
             'most_popular': most_popular_listings
```
- Have a process compute the recommendations for each user and write the results in the **RecommendationsEntry** table (maybe have two tables - active , inactive)
  - Write the script that computes recommendations, at the point connect to database, get datasets, run recommendation algorithm, and save results
- After the recommendations have been saved to the table, the users will see recommendations when they hit the storefront endpoint, they could also refresh the page in ozp-center


### Content based search information:
*Pros*:
* Need to find features to compare for all items
* Does not need to know information on users'
* Can apply various Similarity Algorithms
* Ability to make recommendations to users with unique tastes or requirements
* Can make recommendations as soon they become available
* Can use search history to create recommendations

*Cons*:
* Finding the correct features to recommend on are hard to find
* Can possibly never recommend an item outside of their interests
* Unable to exploit the quality of others users
* Cold-start problem for new users

### User based search information:
* Item-Item vs. User-User filtering comparison *:
* Both methods should perform the same
* In practice, item-item performs better than user-user
  * Reason for item-item being better is because:
    * Items are "simpler" than classifying Users
    * Item Similarity is more meaningful than User Similarity which makes it more useful


### Visualization
![image](https://cloud.githubusercontent.com/assets/1072762/17147155/826dfd2a-532f-11e6-81a0-029305817585.png)


## Videos:
* https://youtu.be/Eeg1DEeWUjA Content Based Recommendation and Collaborative Filtering Recommendation Systems Explained

## Sites
* https://neo4j.com/developer/guide-build-a-recommendation-engine/
* http://datascience.stackexchange.com/questions/8705/collaborative-filtering-using-graph-and-machine-learning
* http://mikelam.azurewebsites.net/beer-recommendations-with-user-based-collaborative-filtering/
* http://docs.celeryproject.org/en/latest/userguide/periodic-tasks.html
  * We could use celery for task scheduling and running the recommendation algorithm.
* https://realpython.com/blog/python/asynchronous-tasks-with-django-and-celery/  is a good starting guide
* http://opensourceconnections.com/blog/2016/06/06/recommender-systems-101-basket-analysis/ good general site for Basket Analysis technique
* http://opensourceconnections.com/blog/2016/09/09/better-recsys-elasticsearch/ How to build a good recommendation engine using Elasticsearch
