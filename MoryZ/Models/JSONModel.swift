//
//  JSONModel.swift
//  DiaryZ
//
//  Created by 周源坤 on 2021/12/4.
//

import Foundation

struct DiaryModel: Codable {
    let title: String
    let content: String
    let mood: String
    let weather: String
    let starred: String
    let createdDate: Date
    let modifiedDate: Date
}

struct DiaryModelWrapper: Codable {
    let diaries: [DiaryModel]
    let createdDate: Date
}

func createDiaryModelFromDiary(diary: Diary) -> DiaryModel {
    return DiaryModel (title: diary.title!, content: diary.content!, mood: diary.mood!, weather: diary.weather!, starred: diary.mean!, createdDate: diary.date!, modifiedDate: diary.lastModifiedTime!)
}

