# FadZmaq API Specification

##### Lachlan Russell | 26/08/19

Method is marked in **bold** when it has been implemented as a template route. 



## Route Specification

| ROUTE              | PURPOSE                               | DATA SENT | DATA RECEIVED                                                | METHOD   |
| ------------------ | ------------------------------------- | --------- | ------------------------------------------------------------ | -------- |
| /auth              | Authentication                        |           |                                                              | POST     |
| /user/recs         | Get recommendations.                  | NULL      | JSON list of of users and their limited public profile information. | **GET**  |
| /user/`id`         | Gets a candidates profile information | NULL      | JSON of candidates profile information                       | **GET**  |
| /user/`id`/`photo` | Get user photo (Alternate domain)     | NULL      | Image                                                        | GET      |
|                    |                                       |           |                                                              |          |
| /profile           | Get your own profile data             |           | JSON of users own profile data.                              | **GET**  |
| /profile/ping      | Set location                          |           | Confirmation                                                 | POST     |
| /profile           | Set search preferences                | Filters   | Confirmation                                                 | POST     |
|                    |                                       |           |                                                              |          |
|                    |                                       |           |                                                              |          |
| /matches           | Receive you current matches           |           |                                                              | **GET**  |
| /matches/`id`​      | Get match profile information         |           |                                                              | **GET**  |
| /matches/`id`      | Un-match a user                       |           |                                                              | DELETE   |
|                    |                                       |           |                                                              |          |
| **Votes**          | *Could be unified*                    |           |                                                              |          |
| /like/`id`         | Like a user                           |           |                                                              | **POST** |
| /pass/`id`         | Pass on a user                        |           |                                                              | **POST** |
|                    |                                       |           |                                                              |          |
|                    |                                       |           |                                                              |          |

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



