//
//  TaskTableViewCell.swift
//  Sakaly
//
//  Created by Ahmed Alaa on 24/06/2023.
//

import UIKit

//Mark: - TaskTableViewCellDelegate
protocol TaskTableViewCellDelegate: AnyObject {
    func deleteButtonTapped(for cell: TaskTableViewCell)
}

class TaskTableViewCell: UITableViewCell {

    
    //Mark: - Outlets.
    @IBOutlet weak var taskImageView: UIImageView!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    
    //Mark: - Properties.
    weak var delegate: TaskTableViewCellDelegate?
    
    //Mark: - LifeCycle Methods.
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Mark: - Actions.
    @IBAction func deleteBtnTapped(_ sender: UIButton) {
        delegate?.deleteButtonTapped(for: self)
    }
    
    //Mark: - Methods.
    func configureCell(task: TasksData) {
        dateAndTimeLabel.text = task.dateTime
        taskLabel.text = task.task
        taskImageView.image = UIImage(named: "todo")
    }
}
