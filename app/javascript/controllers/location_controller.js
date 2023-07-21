// app/javascript/controllers/locations_controller.js

import { Controller } from "@hotwired/stimulus"
import $ from "jquery"

export default class extends Controller {
  static targets = ['selectedRegionId', 'selectProvinceId', 'selectCityId', 'selectBarangayId']

  connect() {
    this.fetchRegions()
  }

  fetchRegions() {
    const target = this.selectedRegionIdTarget
    $(target).empty()

    $.ajax({
      type: 'GET',
      url: '/api/v1/regions/',
      dataType: 'json',
      success: (response) => {
        response.forEach(region => {
          const option = document.createElement('option')
          option.value = region.id
          option.text = region.name
          target.appendChild(option)
        })

        // Automatically select the first region, if available
        if (response.length > 0) {
          const firstRegionId = response[0].id
          this.fetchProvinces(firstRegionId)
        }
      },
      error: (error) => {
        console.error("Error fetching regions:", error)
      }
    })
  }

  fetchProvinces(regionId) {
    const target = this.selectProvinceIdTarget
    $(target).empty()

    $.ajax({
      type: 'GET',
      url: `/api/v1/regions/${regionId}/provinces`,
      dataType: 'json',
      success: (response) => {
        response.forEach(province => {
          const option = document.createElement('option')
          option.value = province.id
          option.text = province.name
          target.appendChild(option)
        })

        // Automatically select the first province, if available
        if (response.length > 0) {
          const firstProvinceId = response[0].id
          this.fetchCities(firstProvinceId)
        }
      },
      error: (error) => {
        console.error("Error fetching provinces:", error)
      }
    })
  }

  fetchCities(provinceId) {
    const target = this.selectCityIdTarget
    $(target).empty()

    $.ajax({
      type: 'GET',
      url: `/api/v1/provinces/${provinceId}/cities`,
      dataType: 'json',
      success: (response) => {
        response.forEach(city => {
          const option = document.createElement('option')
          option.value = city.id
          option.text = city.name
          target.appendChild(option)
        })

        // Automatically select the first city, if available
        if (response.length > 0) {
          const firstCityId = response[0].id
          this.fetchBarangays(firstCityId)
        }
      },
      error: (error) => {
        console.error("Error fetching cities:", error)
      }
    })
  }

  fetchBarangays(cityId) {
    const target = this.selectBarangayIdTarget
    $(target).empty()

    $.ajax({
      type: 'GET',
      url: `/api/v1/cities/${cityId}/barangays`,
      dataType: 'json',
      success: (response) => {
        response.forEach(barangay => {
          const option = document.createElement('option')
          option.value = barangay.id
          option.text = barangay.name
          target.appendChild(option)
        })
      },
      error: (error) => {
        console.error("Error fetching barangays:", error)
      }
    })
  }
}
