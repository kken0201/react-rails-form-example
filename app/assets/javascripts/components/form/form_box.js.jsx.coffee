class FormBox extends React.Component
  constructor: ->
    super
    @state =
      # フォームの値
      data:
        id: ''
        mail: ''
        password: ''
      # エラーメッセージ
      message:
        id: null
        mail: null
        password: null
      # バリデーションの状態
      status:
        id: null
        mail: null
        password: null

  render: ->
    mail =
      mail: this.state.data.mail
      error: this.state.message.mail
      checkValue: this.checkValue
    id =
      id: this.state.data.id
      error: this.state.message.id
      checkValue: this.checkValue
    password =
      password: this.state.data.password
      error: this.state.message.password
      checkValue: this.checkValue

    return (
      `<form autocomplete="off">
          <ul className="form-list">
            <MailInput {...mail} onChange={this.checkValue} />
            <IDInput {...id} onChange={this.checkValue} />
            <PasswordInput {...password} onChange={this.checkValue} />
            <SubmitButton />
          </ul>
        </form>`
    )

  checkValue: (type, value, event) =>
    # console.log 'checkValue! value:'+value+', type:' +type
    # データを一時的に保持するための変数
    data =
      mail: @state.data.mail
      id: @state.data.id
      password: @state.data.password
    message =
      mail: this.state.message.mail
      id: this.state.message.id
      password: this.state.message.password
    status =
      mail: this.state.status.mail
      id: this.state.status.id
      password: this.state.status.password

    # name属性値によって処理を分岐
    switch type
      when 'email'
        # 一時保存用変数に値をセット
        data.mail = value
        if event.target.validationMessage
          message.mail = event.target.validationMessage
          status.mail = false
        else
          message.mail = null
          status.mail = true
        break
      when 'id'
        data.id = value
        if event.target.validationMessage
          message.id = event.target.validationMessage
          status.id = false
        else
          message.id = null
          status.id = true
        break
      when 'password'
        data.password = value
        if event.target.validationMessage
          message.password = event.target.validationMessage
          status.password = false
        else
          message.password = null
          status.password = true
        break

      else
        console.log 'error!'
        break

    # stateを更新
    @setState
      data: data
      message: message
      status: status

    return

# 呼び出し用
window.FormBox = FormBox

# バリデーション共通処理を定義

class CheckValue extends React.Component
  # スタイルの定義
  validStyle:
    invalid:
      border: "2px solid #b71c1c"
    valid:
      border: "2px solid #ccc"

  handleChange: (event) =>
    # フォームのname属性値を取得
    type = event.target.name

    # フォームの入力値を取得
    val = event.target.value

    # 親コンポーネントから受け取るcheckValue()メソッドを実行
    @props.onChange(type, val, event)
    return


class MailInput extends CheckValue
  render: ->
    return (
      `<li>
        <input
          className="input"
          type="email"
          name="email"
          placeholder="メールアドレス"
          value={this.props.mail}
          onChange={this.handleChange}
          onBlur={this.handleChange}
          style={(this.props.error) ? this.validStyle.invalid : this.validStyle.valid}
          required
        />
        <p className="message">{this.props.error}</p>
      </li>`
    )

class IDInput extends CheckValue
  render: ->
    return (
      `<li>
        <input
          className="input"
          type="text"
          name="id"
          pattern="^[0-9A-Za-z]+$"
          placeholder="ユーザーID"
          value={this.props.id}
          onChange={this.handleChange}
          onBlur={this.handleChange}
          style={(this.props.error) ? this.validStyle.invalid : this.validStyle.valid}
          required
        />
        <p className="message">{this.props.error}</p>
      </li>`
    )

class PasswordInput extends CheckValue
  render: ->
    return (
      `<li>
        <input
          className="input"
          type="password"
          name="password"
          autocomplete="off"
          pattern="^[0-9A-Za-z]+$"
          min="3"
          placeholder="パスワード"
          value={this.props.password}
          onChange={this.handleChange}
          onBlur={this.handleChange}
          style={(this.props.error) ? this.validStyle.invalid : this.validStyle.valid}
          required
        />
        <p className="message">{this.props.error}</p>
        <input type="password" style={{display:'none'}} />
      </li>`
    )

class SubmitButton extends React.Component
  render: ->
    return (
      `<li>
        <button className="button">
          登録する
        </button>
      </li>`
    )
