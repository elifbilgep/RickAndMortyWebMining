# Rick and Morty API App

The project involves utilizing the Rick and Morty API to populate a mobile app that displays characters, locations, and episodes. The REST API is central to accessing various resources, with all requests being made over HTTPS and returning JSON data. The app includes features for filtering and sorting characters, episodes, and locations using SwiftUI and following an MVVM architecture.

## Rest
- Base url: https://rickandmortyapi.com/api
- The base url contains information about all available API's resources. All requests are `GET` requests and go over `https`. All responses will return data in `json`.

## Info and Pagination
- The API will automatically paginate the responses. You will receive up to 20 documents per page.
- Each resource contains an `info` object with information about the response.

  | Key | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `count` | `string` | The length of the response |
| `pages` | `string` | The amount of pages|
| `next` | `string(url)` | Link to the next page (if it exists)|
| `prev` | `string(url)` | Link to the previous page (if it exists)|

## API Reference

#### Get character

```https
  GET https://rickandmortyapi.com/api/character/
```

| Path | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `/character` | `string` | Fetchs first 20 characters |

#### Filter & Search Character

```https
  GET https://rickandmortyapi.com/api/character/?name=rick&status=alive
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `name`      | `string` | character's name e.g. rick, morty|
| `status`      | `string` |  character's status e.g. alive, dead|
| `species`      | `string` |  character's species e.g. alien, human |
| `gender` | `string` |  character's gender e.g. female, male |

#### Get Locations

```https
  GET https://rickandmortyapi.com/api/location
```

| Path | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `/location`      | `string` | Fetchs first 20 locations |


#### Filter & Search Locations

```https
  GET https://rickandmortyapi.com/api/location/?name=earth&type=planet
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `/name`      | `string` | Location's name e.g. Abadango, Nuptia|
| `/type`      | `string` | Location's type e.g. earth, dream|


#### Get Episodes

```https
  GET https://rickandmortyapi.com/api/episode
```


| Path | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `/epsiode` | `string` | Fetchs first 20 episodes |


#### Filter & Search Episodes

```https
  GET https://rickandmortyapi.com/api/episode/28
```
| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `/(episodeNumber)` | `string` | Episode number to get episode|
| `/name`      | `string` | Epiosde's name e.g. Anatomy Park|

## Screenshots 
### Filter
<img src="https://github.com/elifbilgep/RickAndMortyWebMining/assets/58171409/7db9ea4f-48b6-4037-ad2b-563e5ca5e21a" alt="drawing" width="200"/> 
<img src="https://github.com/elifbilgep/RickAndMortyWebMining/assets/58171409/442409f9-26bf-4dcc-a830-ca98ebb79bfc" alt="drawing" width="200"/> 
<img src="https://github.com/elifbilgep/RickAndMortyWebMining/assets/58171409/83e633af-a0bb-4651-b8b1-6042395c1bdb" alt="drawing" width="200"/>

### Sort
<img src="https://github.com/elifbilgep/RickAndMortyWebMining/assets/58171409/4976f213-8fd0-43c0-9542-5a2067b6b434" alt="drawing" width="200"/> 
<img src="https://github.com/elifbilgep/RickAndMortyWebMining/assets/58171409/1cc3cc19-2d6b-4847-97ec-93a83ae4960f" alt="drawing" width="200"/> 
<img src="https://github.com/elifbilgep/RickAndMortyWebMining/assets/58171409/b4f2353b-df27-42ca-8166-2a84be226f6e" alt="drawing" width="200"/> 

### Search
<img src="https://github.com/elifbilgep/RickAndMortyWebMining/assets/58171409/520f187f-9b2f-4da0-ba4e-67a5e040d1ff" alt="drawing" width="200"/> 
<img src="https://github.com/elifbilgep/RickAndMortyWebMining/assets/58171409/4666023a-a3e2-4a8b-9edd-8acc181bf5ae" alt="drawing" width="200"/> 
<img src="https://github.com/elifbilgep/RickAndMortyWebMining/assets/58171409/2757ab10-3ae9-4190-9fdb-5e36ba9e39ac" alt="drawing" width="200"/> 
