/* eslint-disable sort-imports */
import { api } from 'lwc';

import LightningModal from 'lightning/modal';

export default class ErrorModal extends LightningModal {
    @api error;
    @api sysAdminView;

    handleOkay() {
        this.close('okay');
    }
}