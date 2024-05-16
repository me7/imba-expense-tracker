type Transaction = {
  text: string
  amount: number
}

type Transactions = {
  income: number
  expense: number
  total: number
  txList: Array<Transaction>
}

type Demo = {
  income: number
}

export {
  Transaction,
  Transactions,
  Demo
}