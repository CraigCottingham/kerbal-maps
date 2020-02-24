import React from "react"

class MapBody extends React.Component {
  constructor (props) {
    super(props)
    this.changeValue = this.changeValue.bind(this)
    this.options = this.props.options
    if (this.options === undefined) {
      this.options = [
        { value:  1, label: "Moho" },
        { value:  2, label: "Eve" },
        { value:  3, label: "Gilly" },
        { value:  4, label: "Kerbin" },
        { value:  5, label: "Mun" },
        { value:  6, label: "Minmus" },
        { value:  7, label: "Duna" },
        { value:  8, label: "Ike" },
        { value:  9, label: "Dres" },
        { value: 10, label: "Jool", disabled: true },
        { value: 11, label: "Laythe" },
        { value: 12, label: "Vall" },
        { value: 13, label: "Tylo" },
        { value: 14, label: "Bop" },
        { value: 15, label: "Pol" },
        { value: 16, label: "Eeloo" }
      ]
    }
  }

  changeValue (event) {
    this.props.onValueChange(event.target.value)
  }

  render () {
    const selectedValue = this.props.selectedValue
    const options = this.options.map((option) =>
      <option key={ "body_" + option.value } value={ option.value } disabled={ option.disabled ? true : false }>{ option.label }</option>
    )

    return (
      <div className="form-group">
        <label htmlFor="select-map-body">Body</label>
        <select id="select-map-body"
                name="select-map-body"
                value={ selectedValue }
                className="form-control"
                onChange={ this.changeValue }>
          { options }
        </select>
      </div>
    )
  }
}

export default MapBody
