# ElasticSearch Upgrade 2.4 to 6.3

## Knowledge Prerequisite
```
https://www.elastic.co/guide/en/elasticsearch/reference/6.3/getting-started.html
https://www.elastic.co/guide/en/elasticsearch/reference/6.3/mapping.htm
https://www.elastic.co/guide/en/elasticsearch/reference/6.3/search-analyzer.html
```

## Affected areas of code
```
amlcenter/api/listing/elasticsearch_util.py
amlcenter/api/listing/model_access_es.py
amlcenter/recommend/recommend_es.py
```

## Steps
* Understand differences between 2.4 and 6.3
* Follow Getting Started Page on ElasticSearch website
* Update Python Elasticsearch dependency
    * https://elasticsearch-py.readthedocs.io/en/master/
* Update `Affected areas of code`
