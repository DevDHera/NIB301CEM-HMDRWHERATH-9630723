//
//  SurveyBrain.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008
//
//  Created by user180410 on 9/19/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import Foundation

struct SurveyBrain {
    let survey = [
        Survey(t: "COVID19 SYMTOMS", q: "Are you having any symptoms above?", i: "survey-1", a: "YES"),
        Survey(t: "AVOID CONTACT WITH SICK PEOPLE", q: "Did you have any contact with a sick person?", i: "survey-2", a: "YES"),
        Survey(t: "AVOID CROWDED PLACES", q: "Have you been exposed to crowded places?", i: "survey-3", a: "YES"),
        Survey(t: "AVOID SHARING FOOD OR CUTLERY", q: "Have you shared food with any sick person?", i: "survey-4", a: "YES"),
        Survey(t: "AVOID TRAVELING", q: "Did you recently travelled aboard?", i: "survey-5", a: "YES"),
    ]
    
    var questionNumber = 0
    var score = 0
    var completed = false
    
    mutating func checkAnswer(_ userAnswer: String) {
        if userAnswer == survey[questionNumber].answer {
            score += 1
        } 
    }
    
    func getQuestionImage() -> String {
        return survey[questionNumber].image
    }
    
    func getQuestionTitle() -> String {
        return survey[questionNumber].title
    }
    
    func getQuestionText() -> String {
        return survey[questionNumber].question
    }
    
    func getProgress() -> Float {
        return Float(questionNumber + 1) / Float(survey.count)
    }
    
    mutating func nextQuestion() {
        if questionNumber < survey.count - 1 {
            questionNumber += 1
        } else {
//            questionNumber = 0
//            score = 0
            completed = true
        }
    }
    
    mutating func resetCounts() {
        questionNumber = 0
        score = 0
    }
    
    func getScore() -> Int {
        return score
    }
    
    func getQuestionNumber() -> Int {
        return questionNumber
    }
    
    func getQuestionCount() -> Int {
        return survey.count
    }
    
    func getCompleted() -> Bool {
        return completed
    }
}
