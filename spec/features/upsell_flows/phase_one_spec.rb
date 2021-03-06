require 'spec_helper'

describe 'phase one workbook flows' do

  it 'funnel 2', js: true, vcr: true do
    visit '/ideal-life?p=a'
    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
    expect(current_path).to eq "/continuity-offer-2"
    submit_order_form
    sleep 1
    expect(current_path).to eq "/action-sidekick"
    find('.purchase-offer-btn-2').click
    sleep 1
    expect(current_path).to eq "/thanks/thank-you-b"
    expect(user.orders.where("subscription_id IS NOT NULL").count).to eq 1
    expect(Order.count).to eq 2
    expect(user.orders.count).to eq 2
    expect(user.subscriptions.count).to eq 1
    expect(user.subscriptions.last).to eq Subscription.first
  end

  it 'funnel 3', js: true, vcr: true do
    visit '/ideal-life?p=a'
    visit '/ideal-life?p=b'
    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
    expect(current_path).to eq "/workbook"
    submit_order_form
    expect(current_path).to eq "/continuity-offer-2"
    #expect(page.html).to include "0ghXCIi7kAgQ8IKw0QM" # GA CONVERSION TRACKING CODE
    find('.purchase-offer-btn-2').click
    sleep 1
    expect(current_path).to eq "/action-sidekick"
    #expect(page.html).to include "6m_yCNC5kQgQ8IKw0QM" # GA CONVERSION TRACKING CODE
    find('.purchase-offer-btn-2').click
    sleep 1

    expect(current_path).to eq "/thanks/thank-you-a"
    expect(user.orders.where("subscription_id IS NOT NULL").count).to eq 1
    expect(user.subscriptions.count).to eq 1
    expect(user.orders.count).to eq 3
    expect(user.subscriptions.last).to eq Subscription.first
  end

  it 'purchase workbook; purchase subscription', js: true, vcr: true do
    visit_workbook
    submit_order_form
    expect(current_path).to eq "/continuity-offer-1"
    reveal_hidden_elements
    find('#purchase-offer-btn').click
    sleep 1
    expect(current_path).to eq "/action-sidekick"
    #expect(page.html).to include "zkILCNi4kQgQ8IKw0QM" # GA CONVERSION TRACKING CODE
    find('.purchase-offer-btn-2').click
    sleep 1
    expect(current_path).to eq "/thanks/thank-you-a"
    expect(user.orders.where("subscription_id IS NOT NULL").count).to eq 1
    expect(user.subscriptions.count).to eq 1
    expect(user.subscriptions.last).to eq Subscription.first
  end

  it 'purchase workbook; decline subscription; purchase trial subscription', js: true, vcr: true do
    visit_workbook
    submit_order_form
    expect(current_path).to eq "/continuity-offer-1"
    reveal_hidden_elements
    find('#decline-offer-btn').click
    expect(current_path).to eq "/continuity-offer-2"
    find('.purchase-offer-btn-2').click
    sleep 1
    expect(current_path).to eq "/action-sidekick"
    #expect(page.html).to include "6m_yCNC5kQgQ8IKw0QM" # GA CONVERSION TRACKING CODE
    find('.purchase-offer-btn-2').click
    sleep 1
    expect(current_path).to eq "/thanks/thank-you-a"
    expect(Subscription.count).to eq 1
    expect(user.subscriptions.count).to eq 1
    expect(user.subscriptions.last).to eq Subscription.first
    sub = user.orders.map(&:subscription).compact.first
    expect(sub).to eq user.subscriptions.last
    expect(sub.stripe_object["table"]["plan"]["table"]["id"]).to eq "2"
  end

  it 'purchase workbook and decline everything else', js: true, vcr: true do
    visit_workbook
    submit_order_form
    expect(current_path).to eq "/continuity-offer-1"
    reveal_hidden_elements
    find('#decline-offer-btn').click
    expect(current_path).to eq "/continuity-offer-2"
    find('.decline-link').click
    expect(current_path).to eq "/action-sidekick"
    find('.btn-decline-purchase').click
    expect(user.subscriptions.count).to eq 0
    expect(current_path).to eq "/thanks/thank-you-d"
  end

  it 'decline workbook; purchase subscription', js: true, vcr: true do
    visit_workbook
    click_link "No thanks"
    expect(current_path).to eq "/continuity-offer-1"
    reveal_hidden_elements

    submit_order_form(email: 'newguy1000@idealme.com')
    sleep 1
    expect(current_path).to eq "/action-sidekick"
    find('.btn-decline-purchase').click

    expect(user.subscriptions.count).to eq 1
    expect(user.subscriptions.last).to eq Subscription.first
    expect(current_path).to eq "/thanks/thank-you-b"
  end

  it 'decline workbook; decline subscription; purchase trial subscription', js: true, vcr: true do
    visit_workbook
    click_link "No thanks"
    expect(current_path).to eq "/continuity-offer-1"
    reveal_hidden_elements

    click_link "No thanks"
    expect(current_path).to eq "/continuity-offer-2"

    submit_order_form(email: 'newguy1000@idealme.com')
    sleep 1
    expect(current_path).to eq "/action-sidekick"
    find('.btn-decline-purchase').click

    expect(user.subscriptions.last).to eq Subscription.first
    sub = user.orders.map(&:subscription).compact.first
    expect(sub).to eq user.subscriptions.last
    expect(sub.stripe_object["table"]["plan"]["table"]["id"]).to eq "2"
    expect(current_path).to eq "/thanks/thank-you-b"
  end

  it "decline workbook; decline subscription; decline trial subscription", js: true, vcr: true do
    visit_workbook
    click_link "No thanks"
    expect(current_path).to eq "/continuity-offer-1"
    reveal_hidden_elements
    find('.btn-decline-purchase').click
    expect(current_path).to eq "/continuity-offer-2"
    click_link "No thanks"
    sleep 1
    expect(current_path).to eq "/action-sidekick"
    find('.btn-decline-purchase').click
    expect(current_path).to eq "/thanks/thank-you-c"
  end

  def reveal_hidden_elements
    page.execute_script("$('#offer-container, #form-container').removeClass('hidden')")
  end

  def user
    User.order("created_at ASC").last
  end

  def visit_workbook
    visit '/'
    expect(current_path).to eq "/"
    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
    expect(current_path).to eq "/workbook"
  end
end
