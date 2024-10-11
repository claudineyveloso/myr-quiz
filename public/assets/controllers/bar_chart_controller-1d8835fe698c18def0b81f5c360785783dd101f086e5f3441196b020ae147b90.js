import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="bar-chart"
export default class extends Controller {
  connect() {
    this.loadChartData();
  }

  loadChartData() {
    fetch(this.urlValue, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
      },
    })
      .then((response) => response.json())
      .then((data) => {
        this.renderChart(data);
      })
      .catch((error) => {
        console.error("Error loading chart data:", error);
      });
  }

  renderChart(data) {
    const ctx = this.element.getContext("2d");

    new Chart(ctx, {
      type: "bar", // Gráfico de barras verticais
      data: {
        labels: data.labels, // Labels dos eixos
        datasets: [
          {
            label: "Média de Respostas", // Título do gráfico
            data: data.values, // Valores para o gráfico
            backgroundColor: "rgba(75, 192, 192, 0.2)", // Cor das barras
            borderColor: "rgba(75, 192, 192, 1)", // Cor da borda das barras
            borderWidth: 1,
          },
        ],
      },
      options: {
        responsive: true,
        scales: {
          y: {
            beginAtZero: true,
          },
        },
      },
    });
  }
};
