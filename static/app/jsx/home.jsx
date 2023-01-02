import React from 'react';
import { render } from 'react-dom';

const HelloWorld = () => (<div>Hello world</div>);

const app = document.getElementById('app');
render(<HelloWorld />, app);