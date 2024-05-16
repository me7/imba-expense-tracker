tag Header
	<self[fs:xl]> "Expense Tracker"

tag Balance
	<self>
		<div> "YOUR BALANCE"
		<div> "${data}"

tag ExpenseIncome
	<self>
		<div> "INCOME +${data[0]}"
		<div> "EXPENSE -${data[1]}"

tag TransactionList
	<self @click.log(data)>
		<div> "History"
		<hr>
		<ul>
			for t in data
				<li> "{t.text} ${t.amount}"

tag AddTransaction
	<self>
		<div> "Add Transaction"
		<hr>
		<label> "Text"
			<input placeholder='Enter text...'>
		<label> "Amount (negative-expense, positive-income)"
			<input placelholder='Enter amount...'>
		<button[bg:purple2 bd:1px]> "Add transaction"

let transactions = [
	{text:'Sneakers', amount: -200}
	{text:'Paycheck', amount: 900}
	{text:'Food', amount: -100}
]

def balance
	let total = 0
	for t in transactions
		total += t.amount
	total

def income
	let total = 0
	for t in transactions
		if t.amount > 0
			total += t.amount
	total

def expense
	let total = 0
	for t in transactions
		if t.amount < 0
			total += t.amount
	total

tag App
	<self>
		<Header>
		<Balance [bg:blue2] data=balance!>
		<ExpenseIncome data=[income!, expense!]>
		<TransactionList[bg:teal2] data=transactions>
		<AddTransaction>

imba.mount <App>
