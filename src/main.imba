tag Header
	<self[fs:xl]> "Expense Tracker"

tag Balance
	<self>
		<div> "YOUR BALANCE"
		<div> "$600"

tag ExpenseIncome
	<self>
		<div> "INCOME +${900}"
		<div> "EXPENSE -${300}"

tag TransactionList
	<self>
		<div> "History"
		<hr>
		<ul>
			for i in [1...4]
				<li> "Sneakers $-200"

tag AddTransaction
	<self>
		<div> "Add Transaction"
		<hr>
		<label> "Text"
			<input placeholder='Enter text...'>
		<label> "Amount (negative-expense, positive-income)"
			<input placelholder='Enter amount...'>
		<button[bg:purple2 bd:1px]> "Add transaction"

tag App
	<self>
		<Header>
		<Balance>
		<ExpenseIncome>
		<TransactionList>
		<AddTransaction>

imba.mount <App>
