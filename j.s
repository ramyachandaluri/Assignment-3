let display = document.getElementById('display');
let operationDisplay = document.getElementById('operation-display');
let currentInput = '';
let operator = null;
let firstOperand = null;
let waitingForSecondOperand = false;

function appendNumber(number) {
    if (waitingForSecondOperand) {
        currentInput = number;
        waitingForSecondOperand = false;
    } else {
        if (number === '.' && currentInput.includes('.')) {
            return; // Prevent multiple decimal points
        }
        currentInput = currentInput === '0' && number !== '.' ? number : currentInput + number;
    }
    display.value = currentInput;
    updateOperationDisplay();
}

function setOperator(nextOperator) {
    if (operator && !waitingForSecondOperand) {
        calculate(); // Calculate result if an operator already exists and we're not waiting for a second operand
    }

    if (currentInput === '') { // If no number is typed yet, allow changing operator
        firstOperand = parseFloat(display.value);
    } else {
        firstOperand = parseFloat(currentInput);
    }

    operator = nextOperator;
    waitingForSecondOperand = true;
    currentInput = ''; // Clear current input for next number
    updateOperationDisplay();
}

function calculate() {
    if (firstOperand === null || operator === null || currentInput === '') {
        return; // Not enough operands or no operator
    }

    let secondOperand = parseFloat(currentInput);
    let result;

    switch (operator) {
        case '+':
            result = firstOperand + secondOperand;
            break;
        case '-':
            result = firstOperand - secondOperand;
            break;
        case '*':
            result = firstOperand * secondOperand;
            break;
        case '/':
            if (secondOperand === 0) {
                alert("Cannot divide by zero!");
                clearDisplay();
                return;
            }
            result = firstOperand / secondOperand;
            break;
        case '%':
            result = firstOperand % secondOperand;
            break;
        default:
            return;
    }

    display.value = roundResult(result);
    operationDisplay.textContent = ${roundResult(firstOperand)} ${operator} ${secondOperand} =;
    firstOperand = result;
    operator = null;
    currentInput = result.toString(); // Set result as current input for potential further calculations
    waitingForSecondOperand = false;
}

function clearDisplay() {
    currentInput = '';
    operator = null;
    firstOperand = null;
    waitingForSecondOperand = false;
    display.value = '0';
    operationDisplay.textContent = '';
}

function backspace() {
    currentInput = currentInput.slice(0, -1);
    if (currentInput === '') {
        currentInput = '0'; // If nothing left, show 0
    }
    display.value = currentInput;
    updateOperationDisplay();
}

function factorial() {
    let num = parseInt(currentInput);
    if (isNaN(num) || num < 0) {
        display.value = "Error";
        operationDisplay.textContent = "Invalid input for n!";
        return;
    }
    if (num === 0 || num === 1) {
        display.value = '1';
        operationDisplay.textContent = ${num}! = 1;
        return;
    }
    let res = 1;
    for (let i = 2; i <= num; i++) {
        res *= i;
    }
    display.value = res.toString();
    operationDisplay.textContent = ${num}! = ${res};
    currentInput = res.toString();
    firstOperand = res; // Update firstOperand for chaining
    operator = null;
    waitingForSecondOperand = false;
}

function updateOperationDisplay() {
    let opStr = '';
    if (firstOperand !== null) {
        opStr += roundResult(firstOperand);
    }
    if (operator !== null) {
        opStr += ` ${operator}`;
    }
    if (currentInput !== '' && !waitingForSecondOperand) {
        opStr += ` ${currentInput}`;
    }
    operationDisplay.textContent = opStr;
}

function roundResult(num) {
    // Rounds to a reasonable number of decimal places to avoid floating point issues
    return Math.round(num * 1000000000) / 1000000000;
}

// Initialize display on load
document.addEventListener('DOMContentLoaded', () => {
    display.value = '0';
    operationDisplay.textContent = '';
});
