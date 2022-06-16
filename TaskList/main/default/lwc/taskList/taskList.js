import { LightningElement, wire, track } from 'lwc';

import { refreshApex } from '@salesforce/apex';

import getTasks from '@salesforce/apex/TaskListService.getTasks';

export default class TaskList extends LightningElement {
    displaySpinner = true;
    displayTaskList;
    noTasks;
    noTasksMessage = '<b>No tasks!</b>';
    parseTasksResponse;
    @track taskList;

    @wire(getTasks)
    parseTasks(value) {
        this.parseTasksResponse = value;
        const {error, data} = value;

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

    handleRefresh() {
        this.displaySpinner = true;
        refreshApex(this.parseTasksResponse);
    }
}