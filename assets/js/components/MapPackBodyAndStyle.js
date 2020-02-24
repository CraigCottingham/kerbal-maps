import React from "react"
import MapBody from "./MapBody.js"
import MapPack from "./MapPack.js"
import MapStyle from "./MapStyle.js"

class MapPackBodyAndStyle extends React.Component {
  constructor (props) {
    super(props)

    this.state = {
      packOptions: this.props.packOptions,
      selectedPack: 1,
      bodyOptions: this.props.bodyOptions,
      selectedBody: 4,
      styleOptions: this.props.styleOptions,
      selectedStyle: "sat"
    }

    this.changeSelectedPack = this.changeSelectedPack.bind(this)
    this.changeSelectedBody = this.changeSelectedBody.bind(this)
    this.changeSelectedStyle = this.changeSelectedStyle.bind(this)
  }

  setPackOptions (newOptions) {
    this.setState(previousState => ({
      packOptions: newOptions
    }))
    if (this.props.onPackOptionsChange !== undefined) {
      this.props.onPackOptionsChange(newOptions)
    }
  }

  changeSelectedPack (value) {
    this.setState(previousState => ({
      selectedPack: value
    }))
    if (this.props.onPackChange !== undefined) {
      this.props.onPackChange(value)
    }
  }

  setBodyOptions (newOptions) {
    this.setState(previousState => ({
      bodyOptions: newOptions
    }))
    if (this.props.onBodyOptionsChange !== undefined) {
      this.props.onBodyOptionsChange(newOptions)
    }
  }

  changeSelectedBody (value) {
    this.setState(previousState => ({
      selectedBody: value
    }))
    if (this.props.onBodyChange !== undefined) {
      this.props.onBodyChange(value)
    }
  }

  setStyleOptions (newOptions) {
    this.setState(previousState => ({
      styleOptions: newOptions
    }))
    if (this.props.onStyleOptionsChange !== undefined) {
      this.props.onStyleOptionsChange(newOptions)
    }
  }

  changeSelectedStyle (value) {
    this.setState(previousState => ({
      selectedStyle: value
    }))
    if (this.props.onStyleChange !== undefined) {
      this.props.onStyleChange(value)
    }
  }

  render() {
    return (
      <form action="#">
        <MapPack options={ this.state.packOptions } selectedValue={ this.state.selectedPack } onValueChange={ this.changeSelectedPack } />
        <MapBody options={ this.state.bodyOptions } selectedValue={ this.state.selectedBody } onValueChange={ this.changeSelectedBody } />
        <MapStyle options={ this.state.styleOptions } selectedValue={ this.state.selectedStyle } onValueChange={ this.changeSelectedStyle } />
      </form>
    )
  }
}

export default MapPackBodyAndStyle
