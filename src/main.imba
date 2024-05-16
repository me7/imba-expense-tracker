import type {Transaction, Transactions} from './types'

class Tx\Transactions
	constructor
		income = 0
		expense = 0
		total = 0
		txList = []

	def load
		txList = JSON.parse(global.localStorage.getItem('imba-expense-tracker')) or []
		for t in transactions
			if t.amount > 0 then income += t.amount else expense += t.amount
			total = income + expense

	def persist
		global.localStorage.setItem('imba-expense-tracker', JSON.stringify(txList))

	def add t\Transaction
		txList.push t
		if t.amount > 0 then income += t.amount else expense += t.amount
		total = income + expense
		persist!

	def del index
		{text, amount} = txList[index]
		if amount > 0 then income += amount else expense += amount
		total = income + expense
		txList.splice(index, 1)
		persist!

	get transactions
		txList

	get balance
		total

	def getIncome
		income

	def getExpense
		expense

let text\string
let amount\number
let tx = new Tx()
tx.load!

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
		tx.del i

	<self @click.log(data)>
		<div> "History"
		<hr>
		<ul>
			for t, i in tx.transactions
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
				<input placeholder='Enter amount...' bind=amount required >
			<button[bg:purple2 bd:1px]> "Add transaction"

tag App
	def handleAdd e
		{text, amount} = e.detail
		tx.add {text, amount}

	<self>
		<Header>
		<Balance [bg:blue2] data=tx.balance>
		<ExpenseIncome[bg:yellow2] data=[tx.getIncome!, tx.getExpense!]>
		<TransactionList[bg:teal2] >
		<AddTransaction[bg:rose2] @onSubmit=handleAdd>

imba.mount <App>
