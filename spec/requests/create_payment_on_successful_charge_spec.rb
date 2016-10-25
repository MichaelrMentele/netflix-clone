require 'spec_helper'

describe "Create payment on successful charge" do 
  let(:event_data) do 
    {
      "id"=> "evt_198YnfFu8RB24okGgqSYXp5Q",
      "object"=> "event",
      "api_version"=> "2016-07-06",
      "created"=> 1477416803,
      "data"=> {
        "object"=> {
          "id"=> "ch_198YnfFu8RB24okGbodFTuk7",
          "object"=> "charge",
          "amount"=> 999,
          "amount_refunded"=> 0,
          "application_fee"=> nil,
          "balance_transaction"=> "txn_198YnfFu8RB24okGxQUUsU6d",
          "captured"=> true,
          "created"=> 1477416803,
          "currency"=> "usd",
          "customer"=> "cus_9RRhZMe8oGhlOL",
          "description"=> nil,
          "destination"=> nil,
          "dispute"=> nil,
          "failure_code"=> nil,
          "failure_message"=> nil,
          "fraud_details"=> {},
          "invoice"=> "in_198YnfFu8RB24okGlrbC1w9q",
          "livemode"=> false,
          "metadata"=> {},
          "order"=> nil,
          "outcome"=> {
            "network_status"=> "approved_by_network",
            "reason"=> nil,
            "risk_level"=> "normal",
            "seller_message"=> "Payment complete.",
            "type"=> "authorized"
          },
          "paid"=> true,
          "receipt_email"=> nil,
          "receipt_number"=> nil,
          "refunded"=> false,
          "refunds"=> {
            "object"=> "list",
            "data"=> [],
            "has_more"=> false,
            "total_count"=> 0,
            "url"=> "/v1/charges/ch_198YnfFu8RB24okGbodFTuk7/refunds"
          },
          "review"=> nil,
          "shipping"=> nil,
          "source"=> {
            "id"=> "card_198YneFu8RB24okGpfKPKExg",
            "object"=> "card",
            "address_city"=> nil,
            "address_country"=> nil,
            "address_line1"=> nil,
            "address_line1_check"=> nil,
            "address_line2"=> nil,
            "address_state"=> nil,
            "address_zip"=> nil,
            "address_zip_check"=> nil,
            "brand"=> "Visa",
            "country"=> "US",
            "customer"=> "cus_9RRhZMe8oGhlOL",
            "cvc_check"=> "pass",
            "dynamic_last4"=> nil,
            "exp_month"=> 11,
            "exp_year"=> 2016,
            "fingerprint"=> "E3jTfASODt8V0ox6",
            "funding"=> "credit",
            "last4"=> "4242",
            "metadata"=> {},
            "name"=> nil,
            "tokenization_method"=> nil
          },
          "source_transfer"=> nil,
          "statement_descriptor"=> nil,
          "status"=> "succeeded"
        }
      },
      "livemode"=> false,
      "pending_webhooks"=> 1,
      "request"=> "req_9RRhmuaE41nqaq",
      "type"=> "charge.succeeded"
    }
  end

  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do 
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the paymet associated with user" do 
    alice = Fabricate(:user, customer_token: "cus_9RRhZMe8oGhlOL")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creats the payment with the amount", :vcr do 
    alice = Fabricate(:user, customer_token: "cus_9RRhZMe8oGhlOL")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference id", :vcr do 
    alice = Fabricate(:user, customer_token: "cus_9RRhZMe8oGhlOL")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_198YnfFu8RB24okGbodFTuk7")
  end
end
