# FadZmaq API Specification

##### Lachlan Russell | 26/08/19

Not all methods have been specified. If 501 is an optional Fail code the route has not been implemented, and may actually return method not allowed.

## Route Specificatoin

| ROUTE                     | PURPOSE                                   | METHOD | SUCCESS | FAIL                |
| ------------------------- | ----------------------------------------- | ------ | ------- | ------------------- |
| /    OR    /index         | Main page                                 | GET    | -       | 308                 |
| /account                  | Create a new account                      | POST   | 201     | 401 / 403           |
| **USERS**                 |                                           |        |         |                     |
| /user/recs                | Get recommendations.                      | GET    | 200     | 401 / 403 / **501** |
| /user/`id`                | Gets a candidates profile information     | GET    | 200     | 401 / 403 / **501** |
| /user/`id`/`photo`        | Get user photo (Alternate domain)         | GET    | 200     | 504                 |
| **PROFILE**               |                                           |        |         |                     |
| /profile                  | Get your own profile data.                | GET    | 200     | 401 / 204           |
| /profile                  | Update profile data                       | POST   | 200     | 401, 500            |
| /profile/ping             | Set location                              | POST   |         | **501**             |
| /profile/hobbies          | Update a users hobbies                    | POST   | 200     | 401 / 500           |
| **Hobbies**               |                                           |        |         |                     |
| /hobbies                  | A list of all available hobbies to choose | GET    | 200     | 500                 |
| **MATCHES**               |                                           |        |         |                     |
| /matches                  | Receive you current matches               | GET    | 200     | 401 / 204           |
| /matches/`id`             | Get match profile information             | GET    | 200     | 401 / 403 / 204     |
| /matches/`id`             | Un-match a user                           | DELETE | 200     | 401 / 403 / **501** |
| /matches/thumbs/up/`id`   | Rate a user up                            | POST   | 200     | 401 / 403 / **501** |
| /matches/thumbs/down/`id` | Rate a user down                          | POST   | 200     | 401 / 403 / **501** |
| **VOTES**                 |                                           |        |         |                     |
| /like/`id`                | Like a user                               | POST   | 200     | 401 / 403 / **501** |
| /pass/`id`                | Pass on a user                            | POST   | 200     | 401 / 403 / **501** |

## GET Data

### /profile

```json
{
    "profile": {
        "user_id": "29f51c08adac957424e06699b81acdb5",
        "name": "John",
        "age": "19",
        "birth-date": "1999-10-04 00:00:00",
        "photo_location": "URL",
        "phone": "0423239199",
        "email": "John@email.com",
        "bio": "Casual cyclist looking for social rides.",
        "contact_details": {
            "phone": "0423239199",
            "email": "John@email.com"
        },
        "profile_fields": [
            {
                "id": 1,
                "name": "About me",
                "display_value": "Casual cyclist looking for social rides."
            }
        ],
        "hobbies": [
            {
                "share": [
                    {
                        "id": 3,
                        "name": "Rock Climbing"
                    }
                ]
            },
            {
                "discover": []
            }
        ]
    }
}
```

### /matches

```json
{
    "matches": [
        {
            "id": "b026324c6904b2a9cb4b88d6d61c81d1",
            "name": "Lachie",
            "photo": "URL"
        },
        {
            "id": "6d7fce9fee471194aa8b5b6e47267f03",
            "name": "Smith",
            "photo": "URL"
        },
        {
            "id": "48a24b70a0b376535542b996af517398",
            "name": "Judy",
            "photo": "URL"
        },
    ]
}
```

### /matches/`id`

```json
{
    "profile": {
        "user_id": "b026324c6904b2a9cb4b88d6d61c81d1",
        "name": "Lachie",
        "age": "20",
        "photo_location": "UEL",
        "contact_details": {
            "phone": "0423199199",
            "email": "Lachie@email.com"
        },
        "profile_fields": [
            {
                "id": 1,
                "name": "About me",
                "display_value": "Avid rock climber and hiking enthusiast."
            }
        ],
        "hobbies": [
            {
                "share": [
                    {
                        "id": 2,
                        "name": "Boating"
                    },
                    {
                        "id": 3,
                        "name": "Rock Climbing"
                    },
                    {
                        "id": 5,
                        "name": "Golf"
                    }
                ]
            },
            {
                "discover": [
                    {
                        "id": 4,
                        "name": "Hiking"
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
             "share": [
                 {
                     "id": 33,
                     "name": "Boxing"
                 }
             ]
         },
         {
             "discover": [
                 {
                     "id": 99,
                     "name": "Netball"
                 }
             ]
         }
     ]
 }
// Receive
// A users current hobbies
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



