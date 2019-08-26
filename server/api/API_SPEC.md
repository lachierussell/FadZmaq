# FadZmaq API Specification

##### Lachlan Russell | 26/08/19



## Route Specification

| ROUTE              | PURPOSE                               | DATA SENT | DATA RECEIVED                                                | METHOD |
| ------------------ | ------------------------------------- | --------- | ------------------------------------------------------------ | ------ |
| /auth              | Authentication                        |           |                                                              | POST   |
| /user/recs         | Get recommendations.                  | NULL      | A list of users and their limited public profile information. | GET    |
| /user/`id`         | Gets a candidates profile information | NULL      | **REMOVE?**                                                  | GET    |
| /user/`id`/`photo` | Get user photo                        | NULL      | Image                                                        | GET    |
|                    |                                       |           |                                                              |        |
| /profile           | Get your own profile data             |           |                                                              | GET    |
| /profile/ping      | Set location                          |           |                                                              | POST   |
| /profile           | Set search preferences                | Filters   | Confirmation                                                 | POST   |
|                    |                                       |           |                                                              |        |
|                    |                                       |           |                                                              |        |
| /matches           | Receive you current matches           |           |                                                              | GET    |
| /matches/`id`​      | Get match profile information         |           |                                                              | GET    |
| /matches/`id`      | Un-match a user                       |           |                                                              | DELETE |
|                    |                                       |           |                                                              |        |
| **Votes**          | *Could be unified*                    |           |                                                              |        |
| /like/`id`         | Like a user                           |           |                                                              | POST   |
| /pass/`id`         | Pass on a user                        |           |                                                              | POST   |
|                    |                                       |           |                                                              |        |
|                    |                                       |           |                                                              |        |

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



