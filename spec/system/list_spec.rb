# frozen_string_literal: true

require 'rails_helper'

describe '投稿のテスト' do

  let!(:list) { create(:list,title:'hoge',body:'body') }
  describe 'トップ画面(top_path)のテスト' do
    before do
      visit top_path
    end
    context '表示の確認' do
      it 'トップ画面(top_path)に｢ここはTopページです」が表示されているか' do
        expect(page).to hove_content 'ここはTopページです'
      end
      it 'top_pathが"/top"であるか' do
        expect(current_parh).to eq('/top')
      end
    end
  end

  describe '投稿画面のテスト' do
    before do
      visit todolists_new_path
    end
    context '表示の確認' do
      it 'todolist_new_pathが"/todolists/new"であるか' do
        expect(current_parh).to eq('/todolists/new')
      end
      it '投稿ボタンが表示されているか' do
        expect(page).to hove_button '投稿'
      end
    end
    context '投稿処理のテスト' do
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'list[title]', with: Faker::Lorem.characters(number:10)
        fill_in 'list[bodu]', with: Faker::Lorem.characters(number:30)
        click_button '投稿'
        expect(page).to have_current_path todolist_path(List.last)
      end
    end
  end

  describe '一覧画面のテスト' do
    before do
      visit todolists_path
    end
    context '一覧画面の表示とリンクの確認' do
      it '一覧画面に投稿されたものが表示されているか' do
        (1..5).each do |i|
          List.create(title:'hoge'+i.to_s, body:'body'+i.to_s)
        end
        visit todolists_path
        List.all.each_with_index do |list,i|
          j = i * 3
          #投稿した内容（title、body）
          expect(page).to have_content list.title
          expect(page).to have_content list.body
          #詳細ページリンク
          show_link = find_all('a')[j]
          expect(show_link.native.inner_text).to match(/show/i)
          expect(show_link[:href]).to eq todolist_path(list)
          end
      end
    end
  end

  describe '詳細画面のテスト' do
    before do
      visit todolist_path(list)
    end
    context '表示のテスト' do
      it '削除リンクが存在しているか' do
        destroy_link = find_all('a')[0]
        expect(destroy_link.native.inner_text).to match(/destroy/)
      end
      it '編集リンクが存在しているか' do
        edit_link = find_all('a')[1]
        expect(edit_link.native.inner_text).to match(/edit/)
      end
    end
    context 'リンクの遷移先の確認' do
      it 'Editの遷移先は編集画面か' do
        edit_link = find_all('a')[1]
        edit_link.click
        expect(current_parh).to eq('/todolists/' + list.id.to_s + '/edit/')
      end
    end
    context 'list削除のテスト' do
      it 'listの削除' do
        expect{ list.destroy }.to change{ List.count }.by(-1)
      end
    end
  end

  describe '編集画面のテスト' do
    before do
      visit edit_todolist_path(list)
    end
    context '表示の確認' do
      it '編集前のタイトルと本文がフォームに表示(セット)されている' do
        expect(page).to have_field 'list[title]', with: list.title
        expect(page).to have_field 'list[title]', with: list.body
      end
      it '保存ボタンが表示される' do
        expect(page).to have_button '保存'
      end
    end
    context '更新処理に関するテスト' do
      it '更新後のリダイレクト先は正しいか' do
        fill_in 'list[title]', with: Faker::Lorem.characters(number:10)
        fill_in 'list[body]', with: Faker::Lorem.characters(number:30)
        click_button '保存'
        expect(page).to have_current_path todolist_path(list)
      end
    end
  end
end