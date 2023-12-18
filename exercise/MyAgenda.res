module Event = {
  type t = {
    name: string,
    startDate: Date.t,
    venue: string,
    price: float,
    affinity: API.Affinity.t,
  }
}


let calculateAffinity = (event) => {
  //function to calculate the affinity to an event
}
let selectBestEvents = (possibleEvents) => {
  //returns the best event for each day using the array of the possibleEvents
}

let oneRecommendationEveryDay = (~maxDistanceInKm, ~maxPrice) => {
  let events = API.Event.nextEvents();      //this element is of option<API.Event.t> type, because of the option type, it doesn't work as intended
  let currentLocation = API.Location.getCurrentLocation();
  let possibleEvents = [];
  let length = size(events)   //this line doesn't work as intended, the goal was to find out the size of the array

  for i in 0 to length {
    let event = events[i];   
    let distance = API.Location.distanceInKm(currentLocation, event.location);

    if distance<maxDistanceInKm && event.price<maxPrice{
      let e = {
          "name": event.name,
          "startDate": event.startDate,
          "venue": event.venue,
          "price": event.price,
          "affinity": calculateAffinity(event)
      }
      possibleEvents.add(e);    //this doesn't work either, the goal was to add the events that matches the requirements in the possibleEvent array
    }
  }

  let bestEvents = selectBestEvents(possibleEvents);

  bestEvents;
}
