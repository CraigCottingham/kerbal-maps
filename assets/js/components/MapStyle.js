import React from "react"

class MapStyle extends React.Component {
  constructor (props) {
    super(props)
    this.changeValue = this.changeValue.bind(this)
    this.options = this.props.options
    if (this.options === undefined) {
      this.options = [
        { value: "biome", label: "Biome" },
        { value: "sat", label: "Satellite" },
        { value: "slope", label: "Slope" }
      ]
    }
  }

  changeValue (event) {
    this.props.onValueChange(event.target.value)
  }

  render() {
    const selectedValue = this.props.selectedValue
    const options = this.options.map((option) =>
      <option key={ "style_" + option.value } value={ option.value }>{ option.label }</option>
    )

    return (
      <div className="form-group">
        <label htmlFor="select-map-style">Style</label>
        <select id="select-map-style"
                name="select-map-style"
                value={ selectedValue }
                className="form-control"
                onChange={ this.changeValue }>
          { options }
        </select>
      </div>
    )
  }
}

export default MapStyle
