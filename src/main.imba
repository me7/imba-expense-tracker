import type {Transaction, Transactions} from './types'
import '@fontsource/lato';

# import './style.css'

global css @root
	#bg3:lch(50 100 100 / 0.5)

css
	body bg:#f7f7f7 d:vflex ja:center min-height:100vh m:0 ff:"Lato", sans-serif fs:18px
	.container m:30px w:100
	h1 m:0 ls:1px
	h3 bdb:1px #bbbbbb pb:10px m:40px 0 10px
	h4 m:0 tt:uppercase
	.inc-exp-container bg:white bxs:lg d:flex p:20px m:20px 0 jc:space-between 
	.inc-exp-container > div@first-of-type fl:1 bdr:1px solid #dedede
	.money fs:20px ls:1px mx:5px
	.money.plus c: #2ecc71
	.money.minus c:#c0392b
	label d:inline-block m:10px 0
	input d:block fs:16px rd:2px bd:1px solid #dedede p:10px w:100%
	.btn p:10px m:10px 0 30px c:white bg:#9c88ff cursor:pointer bd:0 fs:16px

class Tx\Transactions
	constructor
		income\number = 0
		expense\number = 0
		total\number = 0
		txList = []

	def load
		txList = JSON.parse(global.localStorage.getItem('imba-expense-tracker')) or []
		for t in transactions
			if t.amount > 0 then income += t.amount else expense += t.amount
			total = income + expense

	def persist
		global.localStorage.setItem('imba-expense-tracker', JSON.stringify(txList))

	def add t\Transaction
		if t.amount == 0 
			return
		txList.push t
		if t.amount > 0 then income += t.amount else expense += t.amount
		total = income + expense
		persist!

	def del index
		{text, amount} = txList[index]
		if amount > 0 then income -= amount else expense -= amount
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
let	amount
let tx = new Tx()
tx.load!

tag Header
	<self> 
		<h2> "Expense Tracker"

tag Balance
	<self>
		<h4> "Your Balance"
		<h1#balance> "${data}"

tag ExpenseIncome
	<self>
		<div.inc-exp-container>
			<div>
				<h4> "Income"
					<p.money.plus> "+${data[0]}"
			<div>
				<h4> "Expense" 
					<p.money.minus> "${data[1]}"

tag TransactionList
	def handleDelete i
		tx.del i

	<self @click.log(data)>
		<h3> "History"
		<ul>
			for t, i in tx.transactions
				<li> "{t.text} ${t.amount}"
					<button @click=handleDelete(i)> "Delete"

tag AddTransaction
	def onSubmit
		emit('onSubmit', {text, amount: parseFloat(amount) or 0})

	def focus
		$text.focus!

	<self>
		<h3> "Add Transaction"
		<label> "Text"
		<input$text placeholder='Enter text...' bind=text required @keydown.enter=$amount.focus!>
		<label> "Amount (negative-expense, positive-income)"
		<input$amount placeholder='Enter amount...' bind=amount @keydown.enter=$submit.focus!>
		<button$submit .btn @click=onSubmit> "Add transaction"

tag App
	def handleAdd e
		{text, amount} = e.detail
		tx.add {text, amount}
		text = ''
		amount = ''
		$addForm.focus!

	<self>
		<div.container>
			<Header>
			<Balance data=tx.balance>
			<ExpenseIncome data=[tx.getIncome!, tx.getExpense!]>
			<TransactionList >
			<AddTransaction$addForm @onSubmit=handleAdd>

imba.mount <App>
