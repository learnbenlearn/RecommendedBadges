import { LightningElement, api } from 'lwc';

export default class UsageProgressBar extends LightningElement {
    @api description = 'Progress bar';
    @api title;

    _progressBarColorBackground = 'white';
    _progressBarColor = 'black';
    _progressBarPercent;
    progressBarWidth;

    get progressBarColorBackground() {
        return this._progressBarColorBackground;
    }
    @api set progressBarColorBackground(value) {
        this._progressBarColorBackground = value;
    }
    
    get progressBarColor() {
        return this._progressBarColor;
    }
    @api set progressBarColor(value) {
        this._progressBarColor = value;
    }

    get progressBarPercent() {
        return this._progressBarPercent;
    }
    @api set progressBarPercent(value) {
        this._progressBarPercent = value < 0 ? 0 : value;
    }

    renderedCallback() {
        this.progressBarWidth = getComputedStyle(this.template.querySelector('.progress-bar')).getPropertyValue('width').replace('px', '') * this.progressBarPercent / 100;
        if(this.progressBarPercent <= 100) {
            this.template.host.style.setProperty('--progress-bar-width', `${this.progressBarWidth}px`);
        } else {
            this.template.host.style.setProperty('--progress-bar-width', getComputedStyle(this.template.querySelector('.progress-bar')).getPropertyValue('width'));
            this.progressBarColor = 'red';
            this.progressBarColorBackground = 'white';
        }

        this.template.host.style.setProperty('--progress-bar-color', this.progressBarColor);
        this.template.host.style.setProperty('--progress-bar-color-background', this.progressBarColorBackground);
    }
}