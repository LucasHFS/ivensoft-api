# frozen_string_literal: true

json.call(transaction, :id, :quantity)

json.depositId transaction.deposit_id
json.transactionType transaction.transaction_type
json.transactionedAt transaction.transactioned_at.to_fs(:iso8601)
json.productId transaction.product_id
