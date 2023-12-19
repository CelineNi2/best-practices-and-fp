module Event = {
  type t = {
    name: string,
    startDate: Date.t,
    venue: string,
    price: float,
    affinity: API.Affinity.t,
  }
}



let calculateAffinity = (event: API.Event.t) => {
  //function to calculate the affinity toward an event
  let affinity = switch event {
    | {kind: "concert", artists} =>
      Some(API.Affinity.concert(~artists=artists, ~venue=event.venue, ~weather=API.Weather.getForecast(event.location, event.startDate)))
    | {kind: "movie screening"} =>
      Some(API.Affinity.movie(API.Movie.getInfo(~title=event.name)))
    | {kind: "play", director, actors} =>
      Some(API.Affinity.play(~playwright=API.Play.getInfo(~title=event.name).playwright, ~director=director, ~actors=actors))
    | {kind: "student party", artists, affiliatedUniversitiy} =>
      Some(API.Affinity.studentParty(~artists=artists, ~venue=event.venue, ~weather=API.Weather.getForecast(event.location, event.startDate), ~affiliatedUniversity=affiliatedUniversitiy))
    | _ => 
      None
  }
  affinity;
}

let oneRecommendationEveryDay = (~maxDistanceInKm, ~maxPrice) => {
  let events = API.Event.nextEvents()
  let currentLocation = API.Location.getCurrentLocation()
    
  let possibleEvents = Belt.Array.keepMap(events, event => {
    let distance = API.Location.distanceInKm(currentLocation, event.location)

    if distance<maxDistanceInKm && event.price<maxPrice {
      let affinity = calculateAffinity(event)

      let e: option<Event.t> = switch affinity{
        | Some(affinity) => Some({
          Event.name: event.name,
          startDate: event.startDate,
          venue: event.venue,
          price: event.price,
          affinity: affinity})
        | None =>
          None
        }
        e
    } else{None}
  })

  possibleEvents
}
