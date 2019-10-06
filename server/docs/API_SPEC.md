# FadZmaq API Specification

##### Lachlan Russell | 26/08/19

Not all methods have been specified. If 501 is an optional Fail code the route has not been implemented, and may actually return method not allowed.

## Route Specification

| ROUTE                           | PURPOSE                                   | METHOD | SUCCESS | FAIL                |
| ------------------------------- | ----------------------------------------- | ------ | ------- | ------------------- |
| /    OR    /index               | Main page                                 | GET    | -       | 308                 |
| /account                        | Create a new account                      | POST   | 201     | 401 / 403           |
| /account/settings               | Retrieves user settings                   | GET    | 200     | 401 / **501**       |
| /account/settings               | Sets user settings                        | POST   | 200     | 401 / **501**       |
| /account                        | Deletes account and associated data       | DELETE | 204     | 401                 |
| **USERS**                       |                                           |        |         |                     |
| /user/recs                      | Get recommendations.                      | GET    | 200     | 401 / 403 / **501** |
| /user/`id` (deprecated)         | Gets a candidates profile information     | GET    | 200     | 401 / 403 / **501** |
| /user/`id`/`photo` (deprecated) | Get user photo (Alternate domain)         | GET    | 200     | 504                 |
| **PROFILE**                     |                                           |        |         |                     |
| /profile                        | Get your own profile data.                | GET    | 200     | 401                 |
| /profile                        | Update profile data                       | POST   | 200     | 401, 500            |
| /profile/ping                   | Set location                              | POST   |         | **501**             |
| /profile/hobbies                | Update a users hobbies                    | POST   | 200     | 401 / 500           |
| **Hobbies**                     |                                           |        |         |                     |
| /hobbies                        | A list of all available hobbies to choose | GET    | 200     | 500                 |
| **MATCHES**                     |                                           |        |         |                     |
| /matches                        | Receive you current matches               | GET    | 200     | 401                 |
| /matches/`id`                   | Get match profile information             | GET    | 200     | 401 / 403           |
| /matches/`id`                   | Un-match a user                           | DELETE | 200     | 401 / 403 / **501** |
| /matches/thumbs/up/`id`         | Rate a user up                            | POST   | 200     | 401 / 403 / **501** |
| /matches/thumbs/down/`id`       | Rate a user down                          | POST   | 200     | 401 / 403 / **501** |
| **VOTES**                       |                                           |        |         |                     |
| /like/`id`                      | Like a user                               | POST   | 200     | 401 / 403 / **501** |
| /pass/`id`                      | Pass on a user                            | POST   | 200     | 401 / 403 / **501** |

## GET Data

### /user/recs

```json
{
    "recommendations": [
        {
            "rank": 1,
            "user": {
                "user_id": "29f51c08adac957424e06699b81acdb5",
                "name": "John",
                "photo_location": "URL",
                "profile_fields": [
                    {
                        "name": "about me",
                        "display_value": "Avid rock climber and hiking enthusiast."
                    },
                    {
                        "name": "location",
                        "display_value": "<5"
                    }
                ],
                "hobbies": [
                     {
                         "container": "share",
                         "hobbies": [
                             {
                                 "id": 3,
                                 "name": "Rock Climbing"
                             }
                         ]
                     },
                     {
                         "container": "discover",
                         "hobbies": [
                             {
                                 "id": 1,
                                 "name": "Boxing"
                             }
                        ]
                    },
                    {
                        "container": "matched",
                         "hobbies": [
                             {
                                 "id": 1,
                                 "name": "Boxing"
                             }
                        ]
                    }
                ]
            }
        },
        {
            "rank": 2,
            "user": {
                "user_id": "29f51c08adac957424e06699b81acdb5",
                "name": "Amy",
                "photo_location": "URL",
                "profile_fields": [
                    {
                        "name": "about me",
                        "display_value": "Avid rock climber and hiking enthusiast."
                    },
                    {
                        "name": "location",
                        "display_value": "6"
                    }
                ],
                "hobbies": [
                     {
                         "container": "share",
                         "hobbies": [
                             {
                                 "id": 3,
                                 "name": "Rock Climbing"
                             }
                         ]
                     },
                     {
                         "container": "discover",
                         "hobbies": [
                             {
                                 "id": 1,
                                 "name": "Boxing"
                             }
                        ]
                    },
                    {
                        "container": "matched",
                         "hobbies": [
                             {
                                 "id": 1,
                                 "name": "Boxing"
                             }
                        ]
                    }
                ]
            }
        }   
    ]
}
```

### /profile

```json
{
    "profile": {
        "user_id": "29f51c08adac957424e06699b81acdb5",
        "name": "John",
        "photo_location": "URL",
        "profile_fields": [
            {
                "name": "about me",
                "display_value": "Avid rock climber and hiking enthusiast."
            },
            {
                "name": "phone",
                "display_value": "0423199199"
        	},
            {
                "name": "email",
                "display_value": "john@email.com"
        	},
            {
                "name": "age",
                "display_value": "20"
        	},
            {
                "name": "birth-date",
                "display_value": "1999-10-04 00:00:00"
        	},
            {
                "name": "location",
                "display_value": "<5"
        	}
        ],
        "hobbies": [
             {
                 "container": "share",
                 "hobbies": [
                     {
                         "id": 3,
                         "name": "Rock Climbing"
                     }
                 ]
             },
             {
                 "container": "discover",
                 "hobbies": [
                     {
                         "id": 1,
                         "name": "Boxing"
                     }
                 ]
             }
         ]
    }
}
```

### /account/settings

```json
{ "distance_setting": 20 }
```

### /matches

```json
{
    "matches": [
        {
            "id": "b026324c6904b2a9cb4b88d6d61c81d1",
            "name": "Lachie",
            "rating": 0,
            "photo": "URL",
            "hobbies": [
                {
                    "container": "matched",
                    "hobbies": [
                        {
                            "id": 3,
                            "name": "Rock Climbing"
                        },
                        {
                            "id": 1,
                            "name": "Boxing"
                        }
                    ]
                }
            ]
        },
        {
            "id": "48a24b70a0b376535542b996af517398",
            "name": "Judy",
            "rating": null,
            "photo": "URL",
            "hobbies": [
                 {
                     "container": "matched",
                     "hobbies": [
                         {
                             "id": 3,
                             "name": "Rock Climbing"
                         }
                     ]
                 }
             ]
        }
    ]
}
```

### /matches/`id`

```json
{
    "profile": {
        "user_id": "b026324c6904b2a9cb4b88d6d61c81d1",
        "name": "Lachie",
        "photo_location": "URI",
        "profile_fields": [
            {
                "name": "about me",
                "display_value": "Avid rock climber and hiking enthusiast."
            },
            {
                "name": "phone",
                "display_value": "0423199199"
        	},
            {
                "name": "email",
                "display_value": "john@email.com"
        	},
            {
                "name": "age",
                "display_value": "20"
        	},
            {
                "name": "location",
                "display_value": "12"
        	}
        ],
        "hobbies": [
             {
                 "container": "share",
                 "hobbies": [
                     {
                         "id": 3,
                         "name": "Rock Climbing"
                     }
                 ]
             },
             {
                 "container": "discover",
                 "hobbies": [
                     {
                         "id": 1,
                         "name": "Boxing"
                     }
                 ]
             }
         ]
    }
}
```

### /hobbies

```json
{
    "hobby_list": [
        {
            "id": 1,
            "name": "Boxing"
        },
        {
            "id": 2,
            "name": "Boating"
        },
        {
            "id": 3,
            "name": "Rock Climbing"
        },
        {
            "id": 4,
            "name": "Hiking"
        },
        {
            "id": 5,
            "name": "Golf"
        },
        {
            "id": 6,
            "name": "Surfing"
        },
        {
            "id": 7,
            "name": "Cycling"
        }
    ]
}
```

## POST Data

### /account

```json
// POST
{
    "new_user": {
        "email": "lachie@gmail.com",
        "name": "lachie"
    }
}

// Receive
// A UID string
```

### /profile

```json
// POST


// Receive
// equivialent to GET /profile
```

### /profile/hobbies

```json
// POST 
{
     "hobbies": [
         {
             "container": "share",
             "hobbies": [
                 {
                     "id": 3,
                     "name": "Rock Climbing"
                 }
             ]
         },
         {
             "container": "discover",
             "hobbies": [
                 {
                     "id": 1,
                     "name": "Boxing"
                 }
             ]
         }
     ]
}
// Receive
// A users current hobbies
```

### /account/settings

```json
// POST
{ "distance_setting": 20 }
// Recieve 
None
```

### /like/`id`

```json
// POST
none
// Receive
{ "match": true }
```

### /pass/`id`

```
// POST
none
// Receive
{ "match": false }
```

### /matches/thumbs/up/`id`

```json
// POST
none
// Receive
none
```

### /matches/thumbs/up/`id`

```json
// POST
none
// Receive
none
```

### /profile/ping

```json
// POST
{
	"location": {
        // NOTE: Decimal degrees must be 2.dp
        // This provides approximately 1km of resolution.
        "lat": -122.06,
        "long": 37.42
    }	
}

// Recieve
none	
```

## DELETE Data

### /matches/id

```json
// DELETE
none
// Recieve
none		
```

## Error Responses

| ERROR CODE | PURPOSE                | DESCRIPTION                                                  |
| ---------- | ---------------------- | ------------------------------------------------------------ |
| **2xx**    | **Success**            |                                                              |
| 201        | Created                | The request has been fulfilled, resulting in the creation of a new resource |
| 204        | No content             | The server successfully processed the request and is not returning any content |
| **3xx**    | **Redirection**        |                                                              |
| 308        | Permanent Redirect     | Don't come back to this route                                |
| **4xx**    | **Client Error**       |                                                              |
| 400        | Bad request            | The server cannot or will not process the request due to an apparent client error |
| 401        | Unauthorized           | Specifically for use when authentication is required and has failed or has not yet been provided. |
| 403        | Forbidden              | The request was valid, but the server is refusing action.    |
| *          | Not found/ Not allowed | Only handled by client                                       |
| **5xx**    | **Server Error**       |                                                              |
| 500        | Internal server error  | A generic error message, given when an unexpected condition was encountered and no more specific message is suitable. |
| 501        | Not implemented        | The server either does not recognize the request method, or it lacks the ability to fulfil the request. |


