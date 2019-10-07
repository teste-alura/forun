package br.com.alura.forum;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.reactive.AutoConfigureWebTestClient;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.reactive.server.WebTestClient;

@RunWith(SpringRunner.class)
@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
@AutoConfigureWebTestClient
public class ForumApplicationTests {
  @Autowired
  private WebTestClient client;

  @Test
	public void deveResponderOla() {
    client.get().uri("/").exchange()
      .expectStatus().isOk()
      .expectBody(String.class).isEqualTo("Hello World!");
	}
}
