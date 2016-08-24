import React, { Component } from 'react';
import { render} from 'react-dom';

class HelloWorld extends Component {
 
    render = () => {
        return (
            <div>
                Hello world
            </div>
        );
    }
    
}


const app = document.getElementById('app');
render(<HelloWorld/>, app);
