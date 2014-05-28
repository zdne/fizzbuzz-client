# iOS FizzBuzz-as-a-Service Client

This App demonstrates building a robust API client on iOS – client for a **distributed scalable system**.

With no server logic being present on client, no tight coupling and absolutely no (but one) hardcoded URLs, this client is only driven by the API domain-specific semantics. 

This allows significant flexibility when building, scaling and evolving the server. As a result the client is more robust, prone to most but API domain semantics changes. 

In addition it is easier for a client developer to build the client – he or she has just to focus on the API semantics and leave the server leads its intentions. 

Decoupling server from client implementations really shines in an environment where clients **can't be redeployed in real time** e.g. Apple App Store – where redeploying a client takes usually takes a week or so (not taking the time needed for code changes into account).

## Demo Video
Brief video demonstrating changing server implementation by embedding a hundred of FizzBuzz answers into one big answer essentially changing the number of calls from 101 to 2 **without the need to redeploy** (or relaunch!) the client:

<https://vimeo.com/96652680>

## Server Implementation
- [FizzBuzz as a Service Server](https://github.com/zdne/fizzbuzz-hypermedia-server)

## Acknowledgments & Background

- The original idea of FizzBuzz as a Service Hypermedia API is by Stephen Mizell and was described in his [Solving FizzBuzz with Hypermedia][] blog post. Stephen is also author of its [server implementation][] and the example Python client. 

- Later on Steve Klabnik came up with some great comments in his post [Hypermedia FizzBuzz][]. 

- Matthew Dobson build the library for consuming Siren hypermedia media type – [SHMKit][]. He is also author of the original iOS demo client – [FizzBuzzHypermedia][]

[Solving FizzBuzz with Hypermedia]: http://smizell.com/weblog/2014/solving-fizzbuzz-with-hypermedia
[server implementation]: https://github.com/smizell/fizzbuzz-hypermedia-server
[Hypermedia FizzBuzz]: http://words.steveklabnik.com/hypermedia-fizzbuzz
[SHMKit]: https://github.com/mdobson/SHMKit
[FizzBuzzHypermedia]: https://github.com/mdobson/FizzBuzzHypermedia