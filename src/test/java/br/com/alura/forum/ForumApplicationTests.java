package br.com.alura.forum;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.reactive.AutoConfigureWebTestClient;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.http.MediaType;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.reactive.server.WebTestClient;
import org.springframework.web.reactive.function.BodyInserters;

import br.com.alura.forum.controller.dto.TopicoDto;
import br.com.alura.forum.controller.form.TopicoForm;

@RunWith(SpringRunner.class)
@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
@AutoConfigureWebTestClient
public class ForumApplicationTests {
  @Autowired
  private WebTestClient client;

  Long topicoCriado = null;

  @Test
	public void deveResponderOla() {
    client.get().uri("/").exchange()
      .expectStatus().isOk()
      .expectBody(String.class).isEqualTo("Hello World!");
	}

  @Test
	public void deveCriarRecuperarAlterarEApagarTopico() {
    client.post()
      .uri("/topicos")
      .contentType(MediaType.APPLICATION_JSON_UTF8)
      .accept(MediaType.APPLICATION_JSON_UTF8)
      .body(BodyInserters.fromObject(new TopicoForm("Teste1", "Mensagem teste 1", "HTML 5")))
      .exchange()
      .expectStatus()
        .isCreated()
      .expectHeader()
        .exists("Location")
      .expectBody()
        .jsonPath("$.titulo")
          .isEqualTo("Teste1")
        .jsonPath("$.id")
        .value(v -> topicoCriado = v, Long.class);

    client.get()
      .uri("/topicos/{id}", topicoCriado)
      .accept(MediaType.APPLICATION_JSON_UTF8)
      .exchange()
      .expectStatus()
        .isOk()
      .expectBody()
        .jsonPath("$.titulo")
          .isEqualTo("Teste1")
        .jsonPath("$.nomeCurso")
          .isEqualTo("HTML 5")
        .jsonPath("$.mensagem")
          .isEqualTo("Mensagem teste 1");

    client.put()
      .uri("/topicos/{id}", topicoCriado)
      .contentType(MediaType.APPLICATION_JSON_UTF8)
      .accept(MediaType.APPLICATION_JSON_UTF8)
      .body(BodyInserters.fromObject(new TopicoForm("Teste1 alterado", "Mensagem teste alterada", "HTML 5")))
      .exchange()
      .expectStatus()
        .isOk()
      .expectBody()
        .jsonPath("$.id")
          .isEqualTo(topicoCriado)
        .jsonPath("$.titulo")
          .isEqualTo("Teste1 alterado");

    client.delete()
      .uri("/topicos/{id}", topicoCriado)
      .accept(MediaType.APPLICATION_JSON_UTF8)
      .exchange()
      .expectStatus()
        .isOk();
  }
}
