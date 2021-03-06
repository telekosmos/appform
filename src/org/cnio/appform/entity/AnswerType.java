package org.cnio.appform.entity;

import javax.persistence.Entity;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.GeneratedValue;
import javax.persistence.Table;

import static javax.persistence.GenerationType.SEQUENCE;

import java.util.List;
import java.util.ArrayList;

@Entity
@Table (name="answertype")
@PrimaryKeyJoinColumn(name="idanstype")
public class AnswerType extends AnswerItem implements Cloneable{
	@Column(name="pattern")
	private String pattern;

	public AnswerType () {
		super ();
	}
	
	public AnswerType (String name) {
		super (name);
	}
	
	public String getPattern() {
		return pattern;
	}

	public void setPattern(String pattern) {
		this.pattern = pattern;
	}
	
	public Object clone () throws CloneNotSupportedException {
		AnswerType newAnsType = new AnswerType (this.getName());
		newAnsType.setDescription(this.getDescription());
		
		List<Answer> lAnswers = new ArrayList<Answer>();
		List<QuestionsAnsItems> qai = new ArrayList<QuestionsAnsItems>();
		newAnsType.setAnswers(lAnswers);
		newAnsType.setQuestionsAnsItems(qai);
		
		return newAnsType;
	}

}
