## Business Objective
(From Ticket https://github.com/aml-development/aml-backend/issues/192)

Ability to do better search
![](https://raw.githubusercontent.com/aml-development/aml-documentation/master/mockups/marketplace/Center_smartsearch_recommendation.PNG)

Requirement came from https://github.com/aml-development/aml-documentation/wiki/Iteration-53#uiux

## Researched Solutions
We researched 3 possible solutions before deciding on Elasticsearch:    

**Solution 1: Using Postgres**    
http://www.postgresonline.com/journal/archives/169-Fuzzy-string-matching-with-Trigram-and-Trigraphs.html
https://github.com/jleivaizq/djorm-ext-pgtrgm

**Solution 2: Using Elasticsearch**    
[Elasticsearch](https://www.elastic.co/webinars/get-started-with-elasticsearch?elektra=home&storm=banner&iesrc=ctr)
https://qbox.io/blog/how-to-elasticsearch-python-django-part1

Steps:
* Add data to the elasticsearch index in bulk.
* Add some frontend and write some queries.
* Make the index updatable when new data is added, updated or deleted.

**Solution 3: Using Whoosh (Python Indexing) Custom REST implementation**    
[whoosh](https://whoosh.readthedocs.io/en/latest/index.html)

## Current Search
###  Current Ablities:
* Auto complete
 * Using https://twitter.github.io/typeahead.js/ and in the metadata endpoint send a array of all the apps the user can see
* SQL LIKE

### Current Implementation:
* Search_fields: title, description, description_short, tags__name
* Filtered by category, agency, listing_types
* Search is currently using Postgres to get search results (list of listings) from database.
* For every call, it loops through every listing to make sure the user has access to listing using the security marking, the results of the call to see if user has access is cached.
  * ````system_has_access_control(username, i.security_marking):```` in aml/amlcenter/models.py/AccessControlListingManager/for_user
* It currently takes 0.8-2.5 Seconds to get results with warm Redis cache using dummy data.

Example Calls:
````
/api/listings/search/?search=Air+Mail&offset=0&limit=24
/api/listings/search/?search=Air+Mai&offset=0&limit=24&type=web+application&type=widget&agency=Minitrue
````

Code of Interest:
````python
router.register(r'listings/search', views.ListingSearchViewSet, base_name='listingssearch')
````
## NextGen Search
### NextGen Ablities:
* Multifield search
  * https://www.elastic.co/guide/en/elasticsearch/guide/current/multi-field-search.html
* Fuzzy matching
* Auto complete
  * https://www.elastic.co/guide/en/elasticsearch/guide/current/_index_time_search_as_you_type.html
* Relevance search (accuracy of results)
  * http://opensourceconnections.com/blog/2014/06/10/what-is-search-relevancy/
  * https://www.elastic.co/guide/en/elasticsearch/guide/current/controlling-relevance.html
* Performance

### NextGen Requirements:
* Users shall be able to search for listings' title, description, description_short, and tags and filter by category, agency, and listing types for the listings they are authorized to see
* Users shall be able to search listings that they are authorized to see while user types in keyboard (autocomplete)
* Users shall be able to search for misspelled similar listings that they are authorized to see (fuzzy matching)
  * Example:  When user types 'Armail' the result coming back shall contain 'Airmail'

### Restrictions/Requirements
* Access Results can only be cached 24 hours
* Search Storage must have authentication security
* Shall not include delete apps or disabled apps

### Proposed Stories/Tasks

**Story:**    
As a member of the Apps Mall Team, I want to understand the requirements for the new search feature so that I can contribute to the project    

**Acceptance Criteria:**
Team member will review and comprehend wiki page documention - https://github.com/aml-development/aml-documentation/wiki/Smart-Search-(2017)
For each task, individual puts a thumbs up once completed

**Tasks:**    
* Knowlege Task - Each Team Member shall have understanding on what Elasticsearch is used for, the purpose it serves, and the application that appmall will be using it for, and understand the following Elasticsearch concepts:
 * Mapping
 * Indexes
 * Search API
 * Query API
 * Document API
 * Document Format
 * Nested Objects vs Arrays
     * https://www.elastic.co/guide/en/elasticsearch/guide/current/nested-objects.html
* Knowledge Task - Each Team Member shall have understanding on how Elasticsearch API works with Python
* Knowlege Task - Each Team Member shall understand data modeling
 * https://www.elastic.co/guide/en/elasticsearch/guide/current/modeling-your-data.html
* Knowlege Task - Each Team Member shall read 4 parts of the 'elasticsearch-python-django-series' from qbox
 * https://qbox.io/blog/series/elasticsearch-python-django-series
 * https://qbox.io/blog/elasticsearch-and-django-bulk-index

**Story:**    
As a user I want to be able to retrieve search results faster than the current bench marks.     

**Acceptance Criteria:**
Team member will review and comprehend wiki page documention - https://github.com/aml-development/aml-documentation/wiki/Smart-Search-(2017)
For each task, individual puts a thumbs up once completed

**Tasks:**    
* Coding Task - Team Member shall prepare code to increase the performance of checking listing authorization  
* Coding Task - Team Member shall update the backend to not return the full listing information when searching (maybe)
* Coding Task - Team member shall ensure that access results shall only be cached for 24 hours

**Story:**    
As a user I want to see results ordered by relevance so that I can find the app I am looking for faster and easier.

**Acceptance Criteria:**
Team member will review and comprehend wiki page documention - https://github.com/aml-development/aml-documentation/wiki/Smart-Search-(2017)
For each task, individual puts a thumbs up once completed


**Tasks:**
* Devops Task - Team Member shall install elastic search library
* Coding task - Team member shall ensure that elastic search has authentication security
* Coding Task - Team member shall ensure that deleted apps and disabled apps are not included in results (possibly not included in elastic search?)
* Coding Task - Team member shall update backend to use elastic search library for type-ahead and regular search
* Knowledge Task - Team member shall verify that the front-end does not need to be updated

**Story:**    
As a user I want to be able to see listings that are similar to what I searched for so that if I misspell a word I will still be able to easily find the application I was looking for

**Acceptance Criteria:**
Team member will review and comprehend wiki page documention - https://github.com/aml-development/aml-documentation/wiki/Smart-Search-(2017)
For each task, individual puts a thumbs up once completed

**Tasks:**
* Coding Task - Team member shall update backend to provide fuzzy matching results
* Coding Task - Team member shall update the frontend to suggest alternate search terms (maybe)

### Strategies
* Figure out a way that it will not have to ' loops through every listing to make sure the user has access'
  * Do a distinct for all listings' security markings, get a list of it, loop though list to check for user's access, save that in redis,  when searching do a inclusion of listings that have the security markings user's can access

## Learning Resources
* https://qbox.io/blog/series/elasticsearch-python-django-series
* https://qbox.io/blog/elasticsearch-and-django-bulk-index
* https://www.elastic.co/guide/en/elasticsearch/guide/current/complex-core-fields.html


**Relevant Code**
* When a change/delete happens to a listing the hooks in models.py can be use to update the documents.
* Does Search response really need every field in the Serializer in the database

**aml-center search relevant code**
https://github.com/aml-development/aml-center/blob/master/app/js/webapi/Listing.js
https://github.com/aml-development/aml-center/blob/master/app/js/components/discovery/index.jsx

**models.py**
````python
@receiver(post_save, sender=Listing)
def post_save_listing(sender, instance, created, **kwargs):
    cache.delete_pattern("storefront-*")
    cache.delete_pattern("library_self-*")

@receiver(post_delete, sender=Listing)
def post_delete_listing(sender, instance, **kwargs):
    cache.delete_pattern("storefront-*")
    cache.delete_pattern("library_self-*")
````
**OR**
overriding the save and delete function of the model

**Request/Response For Search Results**
````JSON
GET /api/listings/search/?search=Air+Mail&amp;offset=0&amp;limit=24 HTTP/1.1
Authorization: Basic YmlnYnJvdGhlcjpwYXNzd29yZA==  << BigBrother
Content-Type: application/json
````
Response:
````JSON
{
  "count": 30,
  "next": "http://127.0.0.1:8001/api/listings/search/?limit=24&offset=24&search=Air+Mail",
  "previous": null,
  "results": [
    {
      "id": 1,
      "is_bookmarked": true,
      "screenshots": [
        {
          "small_image": {
            "url": "http://127.0.0.1:8001/api/image/10/",
            "id": 10,
            "security_marking": "UNCLASSIFIED"
          },
          "large_image": {
            "url": "http://127.0.0.1:8001/api/image/11/",
            "id": 11,
            "security_marking": "UNCLASSIFIED"
          }
        }
      ],
      "doc_urls": [
        {
          "name": "wiki",
          "url": "http://www.google.com/wiki"
        },
        {
          "name": "guide",
          "url": "http://www.google.com/guide"
        }
      ],
      "owners": [
        {
          "id": 4,
          "user": {
            "username": "wsmith"
          },
          "display_name": "Winston Smith"
        }
      ],
      "categories": [
        {
          "title": "Communication",
          "description": "Moving info between people and things"
        },
        {
          "title": "Productivity",
          "description": "Do more in less time"
        }
      ],
      "tags": [
        {
          "name": "demo"
        },
        {
          "name": "example"
        },
        {
          "name": "tag_0"
        }
      ],
      "contacts": [
        {
          "id": 1,
          "contact_type": {
            "name": "Civillian"
          },
          "secure_phone": null,
          "unsecure_phone": "321-123-7894",
          "email": "osha@stark.com",
          "name": "Osha",
          "organization": "House Stark"
        },
        {
          "id": 3,
          "contact_type": {
            "name": "Military"
          },
          "secure_phone": null,
          "unsecure_phone": "222-324-3846",
          "email": "brienne@stark.com",
          "name": "Brienne Tarth",
          "organization": "House Stark"
        }
      ],
      "intents": [],
      "small_icon": {
        "url": "http://127.0.0.1:8001/api/image/6/",
        "id": 6,
        "security_marking": "UNCLASSIFIED"
      },
      "large_icon": {
        "url": "http://127.0.0.1:8001/api/image/7/",
        "id": 7,
        "security_marking": "UNCLASSIFIED"
      },
      "banner_icon": {
        "url": "http://127.0.0.1:8001/api/image/8/",
        "id": 8,
        "security_marking": "UNCLASSIFIED"
      },
      "large_banner_icon": {
        "url": "http://127.0.0.1:8001/api/image/9/",
        "id": 9,
        "security_marking": "UNCLASSIFIED"
      },
      "agency": {
        "title": "Ministry of Truth",
        "short_name": "Minitrue"
      },
      "last_activity": {
        "action": "APPROVED",
        "activity_date": "2016-08-26T16:49:28.106798Z",
        "description": null,
        "author": {
          "id": 4,
          "user": {
            "username": "wsmith",
            "email": "wsmith@oceania.gov"
          },
          "display_name": "Winston Smith",
          "dn": "Winston Smith wsmith"
        },
        "listing": {
          "unique_name": "aml.test.air_mail",
          "title": "Air Mail",
          "id": 1,
          "agency": {
            "title": "Ministry of Truth",
            "short_name": "Minitrue"
          },
          "small_icon": "http://127.0.0.1:8001/api/image/6/",
          "is_deleted": false
        },
        "change_details": []
      },
      "current_rejection": null,
      "listing_type": {
        "title": "web application"
      },
      "title": "Air Mail",
      "approved_date": "2016-08-26T16:49:28.414100Z",
      "edited_date": "2016-08-26T16:49:28.414130Z",
      "description": "Sends mail via air",
      "launch_url": "https://localhost:8443/demo_apps/centerSampleListings/airMail/index.html",
      "version_name": "1.0.0",
      "unique_name": "aml.test.air_mail",
      "what_is_new": "Nothing really new here",
      "description_short": "Sends airmail",
      "requirements": "None",
      "approval_status": "APPROVED",
      "is_enabled": true,
      "is_featured": true,
      "is_deleted": false,
      "avg_rate": 3,
      "total_votes": 3,
      "total_rate5": 1,
      "total_rate4": 0,
      "total_rate3": 1,
      "total_rate2": 0,
      "total_rate1": 1,
      "total_reviews": 3,
      "iframe_compatible": false,
      "security_marking": "UNCLASSIFIED",
      "is_private": false,
      "required_listings": null
    },
    ....
  ]
}
````
