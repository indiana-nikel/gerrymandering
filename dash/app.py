# Import libraries
import dash
import dash_core_components as dcc
import dash_html_components as html
import dash_bootstrap_components as dbc
from dash.dependencies import Input, Output

import pandas as pd
import plotly.express as px

# Initialize app
external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"]
app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

# Load external datasets
df_states_info = pd.read_csv("state_summary.csv")

# Define app layout
app.layout = html.Div([
    dbc.Row(
        dbc.Col(
            html.H1(
                children="Gerrymandering"
            ),
        )
    ),
    dbc.Row(
        dbc.Col(
            html.H3(
                children="How Machine Learning Can Improve Election Quality"
            ),
        )
    ),
    dbc.Row([
        dbc.Col(
            html.Div([
                html.P(
                    children='''
                        The United States is in a unique situation where there are only two political parties.
                        Other democratic countries tend to have more parties that all keep each other in check,
                        but in the United States, every loss for your opponent is a win for you.
                    '''
                )
            ]),
        ),
        dbc.Col(
            html.Div([
                html.P(
                    children='''
                        One such strategy that arises out of this two-party system is redrawing the electoral map to
                        either favor yourself or disfavor your opponent, also known as "gerrymandering". Since the
                        population flutucates over time, every 10 years a state is able to redraw their electoral
                        districts. The party in power at this time can redraw these districts however they'd like,
                        as long as the district is coninuous (no jumping around) and that all the districts have
                        even populations.
                    '''
                )
            ]),
        )
    ]),
    dbc.Row([
        dbc.Col(
            html.Div([
                dcc.Graph(
                    id="histogram",
                    figure=px.histogram(
                        df_states_info,
                        x="pop_per_seat",
                        nbins=10,
                        title="Population Distribution of Congressional Districts",
                        labels={
                            "pop_per_seat":"Population per Congressional District",
                            "count":"Number of States",
                        },
                        template="plotly_white",
                        width=600,
                    )
                )
            ])
        ),
        dbc.Col(
            html.Div([
                dcc.Graph(
                    id="choropleth",
                    figure=px.choropleth(
                        df_states_info,
                        locations="state_abbrev",
                        color="seats",
                        locationmode="USA-states",
                        scope="usa",
                        hover_name="state_name",
                        hover_data=[
                            "seats"
                        ],
                        title="Number of Congressional Seats by State",
                        labels={
                            "state_abbrev":"State Abbreviation",
                            # "state_name":"State Name",
                            "seats":"Congressional Seats",
                        },
                        template="plotly_white",
                        width=600,
                    )
                )
            ])
        )
    ])
])

# Run app
if __name__ == '__main__':
    app.run_server(debug=True)
