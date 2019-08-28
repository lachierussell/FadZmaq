# FadZmaq API Specification

##### Lachlan Russell | 26/08/19

Method is marked in **bold** when it has been implemented as a template route. 

Not all methods have been specified. Denoted by a TBC in the data field.

## Route Specification

| ROUTE                     | PURPOSE                               | DATA SENT | DATA RECEIVED                                                | METHOD     |
| ------------------------- | ------------------------------------- | --------- | ------------------------------------------------------------ | ---------- |
| **AUTHENTICATION**        |                                       |           |                                                              |            |
| /auth                     | Authentication                        | TBC       | TBC                                                          | POST       |
| **USERS**                 |                                       |           |                                                              |            |
| /user/recs                | Get recommendations.                  | NULL      | JSON list of users and their limited public profile information. Specified in `recs_data.py` | **GET**    |
| /user/`id`                | Gets a candidates profile information | NULL      | JSON of candidates profile information. Specified in `recs_data.py` | **GET**    |
| /user/`id`/`photo`        | Get user photo (Alternate domain)     | NULL      | JPEG photo                                                   | GET        |
| **PROFILE**               |                                       |           |                                                              |            |
| /profile                  | Get your own profile data.            | NULL      | JSON of users own profile data. Specified in `profile_data.py` | **GET**    |
| /profile/ping             | Set location                          | TBC       | TBC                                                          | POST       |
| /profile                  | Set search preferences                | TBC       | TBC                                                          | POST       |
| **MATCHES**               |                                       |           |                                                              |            |
| /matches                  | Receive you current matches           | NULL      | A list of users matches with limited information. Specified in `match_data.py` | **GET**    |
| /matches/`id`​             | Get match profile information         | NULL      | Specific match profile information with included contact information. Specified in `match_data.py` | **GET**    |
| /matches/`id`             | Un-match a user                       | TBC       | TBC                                                          | **DELETE** |
| /matches/thumbs/up/`id`   | Rate a user up                        | TBC       | TBC                                                          | POST       |
| /matches/thumbs/down/`id` | Rate a user down                      | TBC       | TBC                                                          | POST       |
| **VOTES**                 |                                       |           |                                                              |            |
| /like/`id`                | Like a user                           | TBC       | TBC                                                          | **POST**   |
| /pass/`id`                | Pass on a user                        | TBC       | TBC                                                          | **POST**   |

## Error Responses

| ERROR CODE | PURPOSE          | RESPONSE |
| ---------- | ---------------- | -------- |
| **2xx**    | **Success**      |          |
|            |                  |          |
|            |                  |          |
| **3xx**    | **Redirection**  |          |
|            |                  |          |
| **4xx**    | **Client Error** |          |
|            |                  |          |
|            |                  |          |
|            |                  |          |
|            |                  |          |
|            |                  |          |
| **5xx**    | **Server Error** |          |
|            |                  |          |



