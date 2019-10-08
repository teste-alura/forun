package br.com.alura.forum.controller.form;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.Length;

import br.com.alura.forum.modelo.Curso;
import br.com.alura.forum.modelo.Topico;
import br.com.alura.forum.modelo.Usuario;
import br.com.alura.forum.repository.CursoRepository;
import br.com.alura.forum.repository.UsuarioRepository;

public class TopicoForm {
	@NotNull @NotEmpty @Length(min = 5)
	private String titulo;

	@NotNull @NotEmpty @Length(min = 10)
	private String mensagem;

	@NotNull @NotEmpty
  private String nomeCurso;

	@NotNull @NotEmpty
  private String autorNome;

  public TopicoForm(String titulo, String mensagem, String autorNome, String nomeCurso) {
    this.titulo = titulo;
    this.mensagem = mensagem;
    this.autorNome = autorNome;
    this.nomeCurso = nomeCurso;
  }

	public String getTitulo() {
		return titulo;
	}

	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}

	public String getMensagem() {
		return mensagem;
	}

	public void setMensagem(String mensagem) {
		this.mensagem = mensagem;
	}

	public String getAutorId() {
		return autorNome;
	}

	public void setAutorId(String autorNome) {
		this.autorNome = autorNome;
	}

	public String getNomeCurso() {
		return nomeCurso;
	}

	public void setNomeCurso(String nomeCurso) {
		this.nomeCurso = nomeCurso;
	}

  public Topico converter(CursoRepository cursoRepository, UsuarioRepository usuarioRepository) {
    Curso curso = cursoRepository.findByNome(nomeCurso);
    Usuario autor = usuarioRepository.findByNome(autorNome);
		return new Topico(titulo, mensagem, autor, curso);
	}

}
