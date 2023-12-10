import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
    connect() { // auto run when created
        console.log('connected');
    }

    close() {
        this.element.remove();
    }

    disconnect() {
        console.log('disconnected');
    }
}