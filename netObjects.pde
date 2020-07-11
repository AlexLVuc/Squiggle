import processing.net.*;
public class squiggleClient {

}

public class squiggleServer{
  
  int numClients = 0;
  Server server;
  
  void serverEvent(Server someServer, Client someClient) {
    println("We have a new client: " + someClient.ip());
    numClients += 1;
  }
}
