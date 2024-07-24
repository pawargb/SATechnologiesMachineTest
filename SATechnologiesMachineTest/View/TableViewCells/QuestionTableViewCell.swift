//
//  QuestionTableViewCell.swift
//  SATechnologiesMachineTest
//
//  Created by Ganesh Pawar on 13/07/24.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var answerChoiceCollectionView: UICollectionView!
    @IBOutlet weak var questionLabel: UILabel!
    
    var question: QuestionsEntity? {
        didSet {
            answerChoices = question?.answerChoices?.allObjects as? [AnswerChoiceEntity] ?? []
            answerChoices.sort(by: {$0.id < $1.id})
        }
    }
    var answerChoices = [AnswerChoiceEntity]()
    var answerSelected: (() -> Void)?
    var allowAnswerChange: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        answerChoiceCollectionView.delegate = self
        answerChoiceCollectionView.dataSource = self
        answerChoiceCollectionView.register(UINib(nibName: "AnswerChoiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AnswerChoiceCollectionViewCell")
    }

    func setDataOnUI(question: QuestionsEntity) {
        questionLabel.text = question.name
        self.question = question
        markQuestionBold()
        answerChoiceCollectionView.reloadData()
    }
    func markQuestionBold() {
        UIView.animate(withDuration: 2) {
            if self.question?.selectedAnswerChoiceId == 0 {
                self.questionLabel.font = UIFont.boldSystemFont(ofSize: 18)
            } else {
                self.questionLabel.font = UIFont.systemFont(ofSize: 17)
            }
        }
    }
}

extension QuestionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.answerChoices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier : "AnswerChoiceCollectionViewCell", for: indexPath) as? AnswerChoiceCollectionViewCell {
            let answerChoice = self.answerChoices[indexPath.item]
            cell.choiceLabel.text = answerChoice.name
            if let answer = question?.selectedAnswerChoiceId, answer == answerChoice.id {
                cell.choiceLabelSuperView.backgroundColor = .systemBlue
            }
            else {
                cell.choiceLabelSuperView.backgroundColor = .systemGray5
            }
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if allowAnswerChange {
            question?.selectedAnswerChoiceId = self.answerChoices[indexPath.item].id
            CoreDataManager.shared.saveContext()
            answerSelected?()
            markQuestionBold()
            answerChoiceCollectionView.reloadData()

        }
    }
}
