# README

This application implements a payment system which satisfies following requirements

### Application Setup:

* Ruby v3.2.2
* Rails v7.1.0
* Jsubundler - bun
* GoodJob - For background jobs
* Interactor - For service objects
* API Authentication - Based on Bearer token
* Linting - Rubocop
* Functional automation testing - Capybara
* Database - Postgresql

### How to Run Application
* Install Ruby v3.2.2
* Install postgresql
* Install all gems using `bundle install`
* Set up javascript packags using `bun install`
* Set up database
  `bin/rails db:create db:migrate`
* Import users
  * Sample csv file - `tmp/user_import.csv`
  * `rails import:users[<path_to_csv_file>]` 
* Routes
```
Prefix Verb   URI Pattern                                                                                       Controller#Action
                                    root GET    /                                                                                                 pages#home
                                good_job        /good_job                                                                                         GoodJob::Engine
                        new_user_session GET    /users/sign_in(.:format)                                                                          devise/sessions#new
                            user_session POST   /users/sign_in(.:format)                                                                          devise/sessions#create
                    destroy_user_session DELETE /users/sign_out(.:format)                                                                         devise/sessions#destroy
                               merchants GET    /merchants(.:format)                                                                              merchants#index
                                         POST   /merchants(.:format)                                                                              merchants#create
                            new_merchant GET    /merchants/new(.:format)                                                                          merchants#new
                           edit_merchant GET    /merchants/:id/edit(.:format)                                                                     merchants#edit
                                merchant GET    /merchants/:id(.:format)                                                                          merchants#show
                                         PATCH  /merchants/:id(.:format)                                                                          merchants#update
                                         PUT    /merchants/:id(.:format)                                                                          merchants#update
                                         DELETE /merchants/:id(.:format)                                                                          merchants#destroy
                            transactions GET    /transactions(.:format)                                                                           transactions#index
                                         POST   /transactions(.:format)                                                                           transactions#create
                         new_transaction GET    /transactions/new/:transaction_type(.:format)                                                     transactions#new
                              pages_home GET    /pages/home(.:format)                                                                             pages#home

```

* API Routes

```
api POST   /api/transactions/:transaction_type(.:format)
```

* API Token
Set in `api_config.yml`

* Test cases
  * Implemented using rspec, shoulda matchers and capybara
  * To run test suit, run command `rspec spec`
* Integration test cases
  * `spec/system/integration/payment_system_spec.rb`


### Relations:
1.1. Ensure you have merchant and admin user roles (UI)
1.2. Merchants have many payment transactions of diﬀerent types
1.3. Transactions are related (belongs_to)

You can also have follow/referenced transactions that refer/depend to/on
the initial transaction
Authorize Transaction -> Charge Transaction -> Refund Transaction
Authorize Transaction -> Reversal Transaction

* Only approved or refunded transactions can be referenced, otherwise the  submitted transaction will be created with status error
* Ensure you prevent a merchant from being deleted unless there are no
related payment transactions
* Use validations for: uuid, amount > 0, customer_email, status
* Use STI
* Transaction Types
  1) Authorize transaction - has amount and used to hold customer's amount
  2) Charge transaction - has amount and used to conﬁrm the amount is taken from the customer's account and transferred to the merchant
  3) The merchant's total transactions amount has to be the sum of the approved Charge transactions
  4) Refund transaction - has amount and used to reverse a speciﬁcamoun (whole amount) of the Charge Transaction and return it to the customer
    -- Transitions the Charge transaction to status refunded
  5) The approved Refund transactions will decrease the merchant's total transaction amount
    -- Reversal transaction - has no amount, used to invalidate the Authorize Transaction
    -- Transitions the Authorize transaction to status reversed



### Design patterns implemented
* Single Table Inheritance - 
  * Merchant < User, Admin < User 
  * AuthorizeTransation < Transaction, hargeTransaction < Transaction, RefundTransation < Transaction, ReversalTransaction < Transaction
* Polymorphic associations
  * Merchant and Transaction both are associate with Payment as Monetizable and Payment belongs to monetizable
* Scopes
  * Merchant and Transaction both have enum fileds which generate scope automatically
  * ```Merchant.active```, ```Merchant.inactive```
  * ```Transaction.approved```, ```Transaction.refunded```, ```Transaction.reversed```, ```Transaction.error```
* Validations and custom validator object, if necessary
  * Customer validator for Email validation
  * Transaction has custom validation method to verify the amount
* Factory pattern
  * User model implements factory method to create Merchant(```User.create_merchant```) and Admin(```User.create_admin```)
* Meta programming
  * ValidateTransactionParams implement dynamic validation methods for validating different type of requests
* Modules
  * WithReferenceTransaction - Common utilit for transaction classes which are associated with a reference transaction
  * WithPaymentInfo - Common utility for transaction which have payment associated with them
* Class Methods
  * User class has class methods ```create_merchant``` and ```create_admin``` to create certain type of users
* private section
  * Most of tansaction classes have private methods mainly related to validation and hooks to not allow those methods to be access outside the class
* Thin controller
  * Services are implemented using interactor to keep the controllers this
    * ```CreateAuthorizeTransaction```
    * ```CreateChargeTransaction```
    * ```CreateRefundTransaction```
    * ```CreateReversalTransaction```
    * ```ValiadteMerchant```
    * ```ValidateTransactionParams```
    * ```RecacalculateMerchantAmount```
    * ```CreateTransaction```
* Partials
  * For navbar
  * For merchant form
  * Form objects implemented using ```reform``` gem for transaction forms
* Background Job
  * Implemented using goodjob gem
  * ```TransactionCleanerJob``` - cleans old transaction every hour
* Soft delete
  * Transactions are soft deleted by ```TransactionCleanerJob```
* 



