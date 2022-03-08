import { LightningElement, wire } from 'lwc';

import getTasks from '@salesforce/apex/TaskListService.getTasks';

export default class TaskList extends LightningElement {
    displaySpinner = true;
    displayTaskList;
    noTasks;
    noTasksMessage = '<b>No tasks!</b>';
    taskList;

    @wire(getTasks)
    parseTasks({error, data}) {
        if(data) {
            let tasks = data;

            if(tasks.length > 0) {
                this.taskList = [];
    
                for(let task of tasks) {
                    this.taskList.push({
                        'Id': '/' + task.Id,
                        'Subject': task.Subject
                    });
                }

                this.displayTaskList = true;
            } else {
                this.noTasks = true;
            }

            this.displaySpinner = false;
        } else if(error) {
            console.error(error);
        }
    }
}