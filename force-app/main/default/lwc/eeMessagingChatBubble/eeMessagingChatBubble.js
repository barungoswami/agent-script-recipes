import { LightningElement,api} from 'lwc';
/* Contstants */
const AGENT = "Agent";
const ENDUSER = "EndUser";
const CHATBOT = "Chatbot";
const PARTICIPANT_TYPES = [ ENDUSER, AGENT, CHATBOT ];
const MESSAGE_CONTENT_CLASS = "embedded-messaging-message-content";

export default class EeMessagingChatBubble extends LightningElement {
strMessage;
    params = [];
    textContent;
    showCaseForm = false;
    /**
    * Deployment configuration data
    * @type {Object}
    */
    @api configuration;

    /**
    * Conversation entry data
    * @type {Object}
    */
    @api conversationEntry;

    /**
    * Returns the sender of this conversation entry
    * @returns {string}
    */
    get sender() {
        return this.conversationEntry.sender 
            && this.conversationEntry.sender.role;
    }

    /**
    * Returns the class name of the message bubble.
    * @returns {string}
    */
    get generateMessageBubbleClassname() {
        if ( this.isSupportedSender() ) {
            // If the sender is an agent, end user or chatbot, return the appropriate class name
            return `${ MESSAGE_CONTENT_CLASS } ${ this.sender }`;
        } else {
            // If the sender is not supported, throw an error
            throw new Error(
                `Unsupported participant type passed in: ${ this.sender }`
            );
        }
    }

    /**
    * True if the sender is a support participant type.
    * @returns {Boolean}
    */
    isSupportedSender() {
        return PARTICIPANT_TYPES.some(
            ( participantType ) => 
                this.sender === participantType,
        );
    }

    /* Connected Callback */
    connectedCallback() {
        try {
            const entryPayload = 
                JSON.parse( this.conversationEntry.entryPayload );
            if (
                entryPayload.abstractMessage &&
                entryPayload.abstractMessage.staticContent
            ) {
                // Extract the text content from the entry payload
                this.textContent = 
                    entryPayload.abstractMessage.staticContent.text;
            }
        } catch (e) {
            // Handle JSON parsing error
            console.error( e );
        }

        // Matches JSON wrapped between $ symbols
        const JSONRegex = /\$([\s\S]*?)\$/; 

        if ( this.textContent.match( JSONRegex ) ) {
            try {

                let matchedContents = this.textContent.match( JSONRegex );
                // Extract the JSON string from the matched contents
                const JSONString = matchedContents[ 1 ];
                const parsedJSON = JSON.parse( JSONString ); 

                this.params = parsedJSON.params || []; 
                console.log(
                    "parsedJSON:",
                    JSON.stringify( parsedJSON )
                );

                let type = parsedJSON.type ? parsedJSON.type.toLowerCase() : "unknown"; 
                if ( type === "caseform" ) {
                    this.showCaseForm = true; 
                }

                this.textContent = 
                    this.textContent.replace( JSONRegex, "" ).trim();

            } catch ( error ) {

                console.error( 
                    "Error parsing JSON:", 
                    error 
                );
                this.params = [];
                this.textContent = this.textContent.trim();
            }
        } 

        // Log results:
        console.log( 
            "Params:", 
            JSON.stringify( this.params )
        );
        console.log( 
            "textContent:", 
            this.textContent 
        );
    }

    handleCaseClose(event) {
        // This method is called when the case is created successfully
        this.showCaseForm = false;
        console.log( 
            'Message::',
            event.detail.caseNumber
        );
        this.strMessage = event.detail.caseNumber;
    }
}