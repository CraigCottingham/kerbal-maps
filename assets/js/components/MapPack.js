import React from "react"

class MapPack extends React.Component {
  constructor (props) {
    super(props)
    this.changeValue = this.changeValue.bind(this)
    this.options = this.props.options
    if (this.options === undefined) {
      this.options = [
        { value: 1, label: "(stock)" }
      ]
    }
  }

  changeValue (event) {
    this.props.onValueChange(event.target.value)
  }

  render() {
    const selectedValue = this.props.selectedValue
    const options = this.options.map((option) =>
      <option key={ "pack_" + option.value } value={ option.value }>{ option.label }</option>
    )

    return (
      <div className="form-group">
        <label htmlFor="select-map-pack">Planet Pack</label>
        <select id="select-map-pack"
                name="select-map-pack"
                value={ selectedValue }
                className="form-control"
                onChange={ this.changeValue }>
          {options}
        </select>
      </div>
    )
  }
}

export default MapPack
