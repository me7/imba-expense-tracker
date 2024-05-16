let text\string
let amount\number
let transactions = [
	{text:'Sneakers', amount: -200}
	{text:'Paycheck', amount: 900}
	{text:'Food', amount: -100}
]

def load
	transactions = JSON.parse(localStorage.getItem('imba-expense-tracker')) or []

def persist
	localStorage.setItem('imba-expense-tracker', JSON.stringify(transactions))

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
	def handleDelete i
		transactions.splice(i, 1)
		persist!

	<self @click.log(data)>
		<div> "History"
		<hr>
		<ul>
			for t, i in data
				<li> "{t.text} ${t.amount}"
					<button @click=handleDelete(i)> "Delete"

tag AddTransaction
	def onSubmit
		emit('onSubmit', {text, amount: parseFloat(amount) or 0})

	<self>
		<form @submit.prevent=onSubmit>
			<div> "Add Transaction"
			<hr>
			<label> "Text"
				<input placeholder='Enter text...' bind=text required>
			<label> "Amount (negative-expense, positive-income)"
				<input placelholder='Enter amount...' bind=amount required >
			<button[bg:purple2 bd:1px]> "Add transaction"

tag App
	def handleAdd e
		{text, amount} = e.detail
		transactions.push {text, amount}
		persist!

	def setup
		load!

	<self>
		<Header>
		<Balance [bg:blue2] data=balance!>
		<ExpenseIncome[bg:yellow2] data=[income!, expense!]>
		<TransactionList[bg:teal2] data=transactions>
		<AddTransaction[bg:rose2] @onSubmit=handleAdd>

imba.mount <App>
